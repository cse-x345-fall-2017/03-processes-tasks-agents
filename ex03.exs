defmodule Ex03 do

  @moduledoc """

  `Enum.map` takes a collection, applies a function to each element in
  turn, and returns a list containing the result. It is an O(n)
  operation.

  Because there is no interaction between each calculation, we could
  process all elements of the original collection in parallel. If we
  had one processor for each element in the original collection, that
  would turn it into an O(1) operation.

  However, we don't have that many processors on our machines, so we
  have to compromise. If we have two processors, we could divide the
  map into two chunks, process each independently on its own
  processor, then combine the results.

  You might think this would halve the elapsed time, but the reality
  is that the initial chunking of the collection, and the eventual
  combining of the results both take time. As a result, the speed up
  will be less that a factor of two. If the work done in the mapping
  function is time consuming, then the speedup factor will be greater,
  as the overhead of chunking and combining will be relatively less.
  If the mapping function is trivial, then parallelizing the code will
  actually slow it down.

  Your mission is to implement a function

      pmap(collection, process_count, func)

  This will take the collection, split it into n chunks, where n is
  the process count, and then run each chunk through a regular map
  function, but with each map running in a separate process.

  Useful functions include `Enum.count/1`, `Enum.chunk/4` and
 `Enum.concat/1`.

  ------------------------------------------------------------------
  ## Marks available: 30

      Pragmatics
        4  does the code compile and run
        5	does it produce the correct results on any valid data

      Tested
      if tests are provided as part of the assignment: 	
        5	all pass

      Aesthetics
        4 is the program written in an idiomatic style that uses
          appropriate and effective language and library features
        4 is the program well laid out,  appropriately using indentation,
          blank lines, vertical alignment
        3 are names well chosen, descriptive, but not verbose

      Use of language and libraries
        5 elegant use of language features or libraries

  """
  
  defp await_task(task, result_list) do
    result = Task.await(task)
    Enum.concat(result_list, result)
  end

  defp break_into_chunks(collection, process_count) do
    collection
    |> Enum.count
    |> chunk_list(process_count, collection)
  end
  
  defp chunk_list(collection_count, process_count, collection) do
    count = chunk_size(collection_count, process_count)
    Enum.chunk_every(collection, count)
  end

  defp chunk_size(collection_count, process_count) do
    collection_count / process_count
    |> Float.ceil(0)
    |> round
  end

  defp perform_task(collection, function) do
    Enum.map(collection, function)
  end
  
  defp process_chunks(collection, function) do
    collection
    |> spawn_processes(function)  #returns a list of tasks to wait on
    |> wait_on_processes          #waits on task list in order and concats the results
  end

  defp spawn_process(task_list, collection, function, count, count) when is_list(collection) and is_function(function) do
    task_list
  end
    
  defp spawn_process(task_list, collection, function, index, list_length) do
    Enum.at(collection, index)
    |> start_task(function, task_list)
    |> spawn_process(collection, function, index + 1, list_length)
  end
  
  defp spawn_processes(collection, function) do
    list_length = length(collection)
    spawn_process([], collection, function, 0, list_length)
  end
  
  defp start_task(chunk, function, task_list) do
    new_task = Task.async(fn -> perform_task(chunk, function) end)
    task_list ++ [new_task]
  end

  defp wait_on_process(result_list, task_list, count, count) when is_list(task_list) do
    result_list
  end

  defp wait_on_process(result_list, task_list, index, list_length) do
    Enum.at(task_list, index)
    |> await_task(result_list)
    |> wait_on_process(task_list, index + 1, list_length)
  end
  
  defp wait_on_processes(task_list) do
    count = length(task_list)
    wait_on_process([], task_list, 0, count)
  end

  def pmap(collection, process_count, function) do
    collection
    |> break_into_chunks(process_count)
    |> process_chunks(function)
  end

end

ExUnit.start
defmodule TestEx03 do
  use ExUnit.Case
  import Ex03

  test "pmap with 1 process" do
    assert pmap(1..10, 1, &(&1+1)) == 2..11 |> Enum.into([])
  end

  test "pmap with 2 processes" do
    assert pmap(1..10, 2, &(&1+1)) == 2..11 |> Enum.into([])
  end

  test "pmap with 3 processes (doesn't evenly divide data)" do
    assert pmap(1..10, 3, &(&1+1)) == 2..11 |> Enum.into([])
  end

  # The following test will only pass if your computer has
  # multiple processors.
  test "pmap actually reduces time" do
    range = 1..1_000_000
    # random calculation to burn some cpu
    calc  = fn n -> :math.sin(n) + :math.sin(n/2) + :math.sin(n/4)  end

    { time1, result1 } = :timer.tc(fn -> pmap(range, 1, calc) end)
    { time2, result2 } = :timer.tc(fn -> pmap(range, 2, calc) end)

    assert result2 == result1
    assert time2 < time1 * 0.8
  end
  
end
