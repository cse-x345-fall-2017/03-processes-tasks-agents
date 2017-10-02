
defmodule Ex02 do

end

ExUnit.start()

defmodule Test do
  use ExUnit.Case

  @moduledoc """

  In this exercise you'll use agents to implement the counter.

  You'll do this three times, in three different ways.

  ------------------------------------------------------------------
  ## For each test (3 in all):  10

        6 does the code compile and pass the tests
        2 is the program written in an idiomatic style that uses
          appropriate and effective language and library features
        2 is the program well laid out,  appropriately using indentation,
          blank lines, vertical alignment
  """
  

  @doc """
  First uncomment this test. Here you will be inserting code
  to create and access the agent inline, in the test itself.

  Replace the placeholders with your code.
  """

  # test "counter using an agent" do
  #   { :ok, counter } = « your code »
  # 
  #   value   = « your code »
  #   assert value == 0
  # 
  #   value   = « your code »
  #   assert value == 1
  # end

  @doc """
  Next, uncomment this test, and add code to the Ex02 module at the
  top of this file to make those tests run.
  """

  # test "higher level API interface" do
  #   count = Ex02.new_counter(5)
  #   assert  Ex02.next_value(count) == 5
  #   assert  Ex02.next_value(count) == 6
  # end

  @doc """
  Last (for this exercise), we'll create a global counter by adding
  two new functions to Ex02. These will use an agent to store the
  count, but how can you arrange things so that you don't need to pass
  that agent into calls to `global_next_value`?
  """

  # test "global counter" do
  #   Ex02.new_global_counter
  #   assert Ex02.global_next_value == 0
  #   assert Ex02.global_next_value == 1
  #   assert Ex02.global_next_value == 2
  # end
end






