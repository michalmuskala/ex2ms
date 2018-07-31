defmodule Ex2ms do
  @moduledoc """
  This module provides the `Ex2ms.fun/1` macro for translating Elixir functions
  to match specifications.
  """

  defmacro fun(data) do
    quote do
      Ex2ms.ets_spec(unquote(data))
    end
  end

  defmacro ets_spec(do: clauses) do
    env =
      quote do
        import Kernel, only: []
        import Ex2ms.Guard
        __ENV__
      end
    {env, _} = Code.eval_quoted(env, [], __CALLER__)

    ast_to_spec(clauses, env)
  end

  defmacro trace_spec(do: clauses) do
    env =
      quote do
        import Kernel, only: []
        import Ex2ms.Guard
        import Ex2ms.Trace
        __ENV__
      end
    {env, _} = Code.eval_quoted(env, [], __CALLER__)

    ast_to_spec(clauses, env)
  end

  defmacro free_spec(do: clauses) do
    env =
      quote do
        import Kernel, only: []
        import Ex2ms.Guard
        __ENV__
      end
    {env, _} = Code.eval_quoted(env, [], __CALLER__)

    ast_to_spec(clauses, env)
  end

  defp ast_to_spec(clauses, env) when is_list(clauses) do
    Enum.map(clauses, &clause_to_ms(&1, env))
  end

  defp clause_to_ms({:->, _, [[arg], body]}, env) do
    {head, guards} = collect_guards(arg, [])
    {head, state} = expand_head(Macro.expand(head, env), env)
    guards = Enum.map(guards, &expand_guard(&1, state, env))
    body = expand_body(body, state, env)
    {:{}, [], [head, guards, body]}
  end

  defp collect_guards({:when, _, [param, guard]}, acc) do
    collect_guards(param, [guard | acc])
  end

  defp collect_guards(other, acc) do
    {other, Enum.reverse(acc)}
  end

  defguard is_var(name, ctx) when is_atom(name) and is_atom(ctx)

  defguard is_literal(value) when is_atom(value) or is_binary(value) or is_number(value)

  defp expand_head({:=, _, [{name, _, ctx} = var, value]}, env) when is_var(name, ctx) do
    expand_head(Macro.expand(value, env), %{var_id(var) => :"$_"}, env)
  end

  defp expand_head({:=, _, [value, {name, _, ctx} = var]}, env) when is_var(name, ctx) do
    expand_head(Macro.expand(value, env), %{var_id(var) => :"$_"}, env)
  end

  defp expand_head({name, _, ctx} = var, _env) when is_var(name, ctx) do
    {:_, %{var_id(var) => :"$_"}}
  end

  defp expand_head(other, env) do
    expand_head(other, %{}, env)
  end

  defp expand_head({:_, _, ctx}, state, _env) when is_atom(ctx) do
    {:_, state}
  end

  defp expand_head({name, _, ctx} = var, state, _env) when is_var(name, ctx) do
    case Map.fetch(state, var_id(var)) do
      {:ok, name} ->
        {name, state}

      :error ->
        name = :"$#{map_size(state) + 1}"
        {name, Map.put(state, var_id(var), name)}
    end
  end

  defp expand_head({:{}, _, list}, state, env) when is_list(list) do
    {list, state} = Enum.map_reduce(list, state, &expand_head(Macro.expand(&1, env), &2, env))
    {{:{}, [], list}, state}
  end

  defp expand_head({:^, _, [value]}, state, _env) do
    {value, state}
  end

  defp expand_head({:%{}, _, kvs}, state, env) do
    {kvs, state} =
      Enum.map_reduce(kvs, state, fn {key, value}, state ->
        {key, state} = expand_head(Macro.expand(key, env), state, env)
        {value, state} = expand_head(Macro.expand(value, env), state, env)
        {{key, value}, state}
      end)

    {{:%{}, [], kvs}, state}
  end

  defp expand_head({left, right}, state, env) do
    expand_head({:{}, [], [left, right]}, state, env)
  end

  defp expand_head(list, state, env) when is_list(list) do
    Enum.map_reduce(list, state, &expand_head(Macro.expand(&1, env), &2, env))
  end

  defp expand_head(value, state, _env) when is_literal(value) do
    {value, state}
  end

  defp expand_guard({name, _, ctx} = var, state, _env) when is_var(name, ctx) do
    # TODO: error handling
    Map.fetch!(state, var_id(var))
  end

  defp expand_guard({:{}, _, list}, state, env) when is_list(list) do
    {:{}, [], [{:{}, [], Enum.map(list, &expand_guard(&1, state, env))}]}
  end

  defp expand_guard({:%{}, _, kvs}, state, env) do
    kvs =
      Enum.map(kvs, fn {key, value} ->
        {expand_guard(key, state, env), expand_guard(value, state, env)}
      end)

    {:%{}, [], kvs}
  end

  defp expand_guard({:^, _, [value]}, _state, _env) do
    value
  end

  defp expand_guard({name, _, args} = fun, state, env) when is_atom(name) and is_list(args) do
    case Macro.expand(fun, env) do
      {:{}, _, [fun | args]} when is_atom(fun) ->
        {:{}, [], [fun | Enum.map(args, &expand_guard(&1, state, env))]}
      other -> raise "invalid call: #{inspect other}"
    end
  end

  defp expand_guard({left, right}, state, env) do
    expand_guard({:{}, [], [left, right]}, state, env)
  end

  defp expand_guard(list, state, env) when is_list(list) do
    Enum.map(list, &expand_guard(&1, state, env))
  end

  defp expand_guard(value, _state, _env) when is_literal(value) do
    value
  end

  defp expand_body({:__block__, _, exprs}, state, env) when is_list(exprs) do
    Enum.map(exprs, &expand_guard(&1, state, env))
  end

  defp expand_body(ast, state, env) do
    expand_guard(ast, state, env)
  end

  defp var_id({name, meta, ctx}), do: {name, Keyword.get(meta, :counter, ctx)}
end
