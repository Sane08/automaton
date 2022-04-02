defmodule AutomatonSolverTest do
  use ExUnit.Case
  doctest AutomatonSolver

  test "Automaton 1" do
    simple_automaton = [
      {:q0, "a", :q1},
      {:q0, "b", :q2},
      {:q1, "a", :q0},
    ]
		assert AutomatonSolver.automatonAcceptsInput("b", simple_automaton, [:q0], [:q2])
		assert AutomatonSolver.automatonAcceptsInput("aaaab", simple_automaton, [:q0], [:q2])
		assert not AutomatonSolver.automatonAcceptsInput("aaaaba", simple_automaton, [:q0], [:q2])
		assert not AutomatonSolver.automatonAcceptsInput("a", simple_automaton, [:q0], [:q2])
		assert not AutomatonSolver.automatonAcceptsInput("aa", simple_automaton, [:q0], [:q2])
		assert not AutomatonSolver.automatonAcceptsInput("ab", simple_automaton, [:q0], [:q2])
  end

  test "Automaton 2" do
    automaton_with_empty_transition = [
      {:q0, "a", :q1},
      {:q0, "b", :q2},
      {:q1, nil, :q3},
			{:q2, "b", :q0},
			{:q3, "b", :q3},
			{:q3, "a", :q4},
    ]
		assert AutomatonSolver.automatonAcceptsInput("bbaba", automaton_with_empty_transition, [:q0], [:q4])
		assert AutomatonSolver.automatonAcceptsInput("bbbbabba", automaton_with_empty_transition, [:q0], [:q4])
		assert AutomatonSolver.automatonAcceptsInput("aba", automaton_with_empty_transition, [:q0], [:q4])
		assert AutomatonSolver.automatonAcceptsInput("aa", automaton_with_empty_transition, [:q0], [:q4])
		assert not AutomatonSolver.automatonAcceptsInput("bba", automaton_with_empty_transition, [:q0], [:q4])
		assert not AutomatonSolver.automatonAcceptsInput("bbab", automaton_with_empty_transition, [:q0], [:q4])
		assert not AutomatonSolver.automatonAcceptsInput("baba", automaton_with_empty_transition, [:q0], [:q4])
		assert not AutomatonSolver.automatonAcceptsInput("abb", automaton_with_empty_transition, [:q0], [:q4])
  end

  test "Automaton 3" do
    automaton_with_empty_loop = [
      {:q0, "a", :q0},
      {:q0, "b", :q1},
      {:q0, "a", :q2},
			{:q1, nil, :q2},
			{:q2, nil, :q3},
			{:q3, nil, :q2},
			{:q2, "b", :q0},
			{:q3, "b", :q4},
			{:q4, "a", :q5},
    ]
		assert AutomatonSolver.automatonAcceptsInput("a", automaton_with_empty_loop, [:q0], [:q2, :q5])
		assert not AutomatonSolver.automatonAcceptsInput("b", automaton_with_empty_loop, [:q0], [:q2, :q5])
		assert not AutomatonSolver.automatonAcceptsInput("ababab", automaton_with_empty_loop, [:q0], [:q2, :q5])
		assert AutomatonSolver.automatonAcceptsInput("abba", automaton_with_empty_loop, [:q0], [:q2, :q5])
		assert AutomatonSolver.automatonAcceptsInput("bba", automaton_with_empty_loop, [:q0], [:q2, :q5])
		assert AutomatonSolver.automatonAcceptsInput("aa", automaton_with_empty_loop, [:q0], [:q2, :q5])
		assert not AutomatonSolver.automatonAcceptsInput("bb", automaton_with_empty_loop, [:q0], [:q2, :q5])
		assert not AutomatonSolver.automatonAcceptsInput("ba", automaton_with_empty_loop, [:q0], [:q2, :q5])
		assert not AutomatonSolver.automatonAcceptsInput("abb", automaton_with_empty_loop, [:q0], [:q2, :q5])
		assert not AutomatonSolver.automatonAcceptsInput("bbab", automaton_with_empty_loop, [:q0], [:q2, :q5])
  end
end
