defmodule DeterministicAutomatonSolver do

  def transistionState(current_state, rules, input) do
    rules = Enum.filter(rules, fn x -> elem(x, 0) == current_state end)
    Enum.filter(rules, &(elem(&1, 1)) == input) |> Enum.map(&elem(&1, 2))
  end

  def analyzeInput(input, transitions, current_state, accepting_states) do
    IO.inspect(input)
    if length(input) > 0 do
      current_input = hd(input)
      next_states = transistionState(current_state, transitions, current_input)
      analyzeInput(tl(input), transitions, hd(next_states), accepting_states)
    else
       Enum.member?(accepting_states, current_state)
    end
  end

  def automatonAcceptsInput(input, transitions, initial_state, accepting_states) do
    answer = analyzeInput(String.split(input, "", trim: true), transitions, initial_state, accepting_states)
    IO.inspect(answer)
  end
end

DeterministicAutomatonSolver.automatonAcceptsInput("aabaa", [{:q0, "a", :q1}, {:q0, "b", :q2}, {:q1, "a", :q0}, {:q1, "b", :q1}, {:q2, "a", :q0}, {:q2, "b", :q2}], :q0, [:q0, :q1])
