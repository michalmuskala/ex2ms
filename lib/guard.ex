defmodule Ex2ms.Guard do
  defmacro is_atom(arg) do
    quote(do: {:is_atom, unquote(arg)})
  end

  defmacro is_float(arg) do
    quote(do: {:is_float, unquote(arg)})
  end

  defmacro is_integer(arg) do
    quote(do: {:is_integer, unquote(arg)})
  end

  defmacro is_list(arg) do
    quote(do: {:is_list, unquote(arg)})
  end

  defmacro is_number(arg) do
    quote(do: {:is_number, unquote(arg)})
  end

  defmacro is_pid(arg) do
    quote(do: {:is_pid, unquote(arg)})
  end

  defmacro is_port(arg) do
    quote(do: {:is_port, unquote(arg)})
  end

  defmacro is_reference(arg) do
    quote(do: {:is_reference, unquote(arg)})
  end

  defmacro is_tuple(arg) do
    quote(do: {:is_tuple, unquote(arg)})
  end

  defmacro is_map(arg) do
    quote(do: {:is_map, unquote(arg)})
  end

  defmacro is_binary(arg) do
    quote(do: {:is_binary, unquote(arg)})
  end

  defmacro is_function(arg) do
    quote(do: {:is_function, unquote(arg)})
  end

  defmacro is_record(arg1, arg2) do
    quote(do: {:is_record, unquote(arg1), unquote(arg2)})
  end

  defmacro is_seq_trace() do
    quote(do: {:is_seq_trace})
  end

  defmacro left and right do
    quote(do: {:andalso, unquote(left), unquote(right)})
  end

  defmacro left or right do
    quote(do: {:orelse, unquote(left), unquote(right)})
  end

  defmacro not value do
    quote(do: {:not, unquote(value)})
  end

  defmacro +value do
    quote(do: {:+, unquote(value)})
  end

  defmacro left + right do
    quote(do: {:+, unquote(left), unquote(right)})
  end

  defmacro -value do
    quote(do: {:-, unquote(value)})
  end

  defmacro left - right do
    quote(do: {:-, unquote(left), unquote(right)})
  end

  defmacro left * right do
    quote(do: {:*, unquote(left), unquote(right)})
  end

  defmacro left / right do
    quote(do: {:/, unquote(left), unquote(right)})
  end

  defmacro div(left, right) do
    quote(do: {:div, unquote(left), unquote(right)})
  end

  defmacro rem(left, right) do
    quote(do: {:rem, unquote(left), unquote(right)})
  end

  defmacro band(left, right) do
    quote(do: {:band, unquote(left), unquote(right)})
  end

  defmacro bor(left, right) do
    quote(do: {:bor, unquote(left), unquote(right)})
  end

  defmacro bxor(left, right) do
    quote(do: {:bxor, unquote(left), unquote(right)})
  end

  defmacro bnot(value) do
    quote(do: {:bnot, unquote(value)})
  end

  defmacro bsl(left, right) do
    quote(do: {:bsl, unquote(left), unquote(right)})
  end

  defmacro bsr(left, right) do
    quote(do: {:bsr, unquote(left), unquote(right)})
  end

  defmacro left > right do
    quote(do: {:>, unquote(left), unquote(right)})
  end

  defmacro left >= right do
    quote(do: {:>=, unquote(left), unquote(right)})
  end

  defmacro left < right do
    quote(do: {:<, unquote(left), unquote(right)})
  end

  defmacro left <= right do
    quote(do: {:<=, unquote(left), unquote(right)})
  end

  defmacro left == right do
    quote(do: {:==, unquote(left), unquote(right)})
  end

  defmacro left === right do
    quote(do: {:"=:=", unquote(left), unquote(right)})
  end

  defmacro left != right do
    quote(do: {:"/=", unquote(left), unquote(right)})
  end

  defmacro left !== right do
    quote(do: {:"=/=", unquote(left), unquote(right)})
  end

  defmacro abs(value) do
    quote(do: {:abs, unquote(value)})
  end

  defmacro elem(left, right) do
    quote(do: {:element, unquote(left), unquote(increment(right))})
  end

  defmacro hd(value) do
    quote(do: {:hd, unquote(value)})
  end

  defmacro length(value) do
    quote(do: {:length, unquote(value)})
  end

  defmacro node() do
    quote(do: {:node})
  end

  defmacro node(value) do
    quote(do: {:node, unquote(value)})
  end

  defmacro round(value) do
    quote(do: {:round, unquote(value)})
  end

  defmacro size(value) do
    quote(do: {:size, unquote(value)})
  end

  defmacro map_size(value) do
    quote(do: {:map_size, unquote(value)})
  end

  defmacro tl(value) do
    quote(do: {:tl, unquote(value)})
  end

  defmacro trunc(value) do
    quote(do: {:trunc, unquote(value)})
  end

  defmacro self() do
    quote(do: {:self})
  end

  defmacro float(value) do
    quote(do: {:float, unquote(value)})
  end

  defp increment(integer) when Kernel.is_integer(integer), do: Kernel.+(integer, 1)

  defp increment(integer) do
    quote do
      {:+, unquote(integer), 1}
    end
  end
end
