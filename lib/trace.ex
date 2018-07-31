defmodule Ex2ms.Trace do
  defmacro set_seq_token(arg1, arg2) do
    quote(do: {:set_seq_token, unquote(arg1), unquote(arg2)})
  end

  defmacro get_seq_token() do
    quote(do: {:get_seq_token})
  end

  defmacro message(value) do
    quote(do: {:message, unquote(value)})
  end

  defmacro return_trace() do
    quote(do: {:return_trace})
  end

  defmacro exceptipn_trace() do
    quote(do: {:exception_trace})
  end

  defmacro process_dump() do
    quote(do: {:process_dump})
  end

  defmacro enable_trace(value) do
    quote(do: {:enable_trace, unquote(value)})
  end

  defmacro enable_trace(arg1, arg2) do
    quote(do: {:enable_trace, unquote(arg1), unquote(arg2)})
  end

  defmacro disable_trace(value) do
    quote(do: {:disable_trace, unquote(value)})
  end

  defmacro disable_trace(arg1, arg2) do
    quote(do: {:disable_trace, unquote(arg1), unquote(arg2)})
  end

  defmacro display(value) do
    quote(do: {:display, unquote(value)})
  end

  defmacro caller() do
    quote(do: {:caller})
  end

  defmacro set_tcw(value) do
    quote(do: {:set_tcw, unquote(value)})
  end

  defmacro silent(value) do
    quote(do: {:silent, unquote(value)})
  end

  defmacro trace(arg1, arg2) do
    quote(do: {:trace, unquote(arg1), unquote(arg2)})
  end

  defmacro trace(arg1, arg2, arg3) do
    quote(do: {:trace, unquote(arg1), unquote(arg2), unquote(arg3)})
  end
end
