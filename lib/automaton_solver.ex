defmodule AutomatonSolver do

  def transistionState(current_state, rules, input) do
    rules = Enum.filter(rules, fn x -> elem(x, 0) == current_state end)
    {(Enum.filter(rules, &(elem(&1, 1)) == input) |> Enum.map(&elem(&1, 2))),
     (Enum.filter(rules, &is_nil(elem(&1, 1))) |> Enum.map(&elem(&1, 2)))}
  end

  def checkTransitions(input, nil_next_states, repeated_nil_transitions, nil_next_states_to_be_analyzed \\ []) do
    if length(nil_next_states) > 0 do
      joint_input = Enum.join(input)
      input_next_state_set = joint_input <> Atom.to_string(hd(nil_next_states))
      if Enum.member?(repeated_nil_transitions, input_next_state_set) do
        checkTransitions(input, tl(nil_next_states), repeated_nil_transitions, nil_next_states_to_be_analyzed)
      else
        checkTransitions(input, tl(nil_next_states), repeated_nil_transitions ++ [input_next_state_set],
                        nil_next_states_to_be_analyzed ++ [hd(nil_next_states)])
      end
    else
      {repeated_nil_transitions, nil_next_states_to_be_analyzed}
    end
  end

  def analyzeInput(input, transitions, current_state_array, repeated_transitions \\ []) do
    cond do
      length(input) > 0 && current_state_array != [] ->
        current_state = hd(current_state_array)
        current_input = hd(input)
        {next_states, nil_next_states} = transistionState(current_state, transitions, current_input)
        {repeated_transitions, nil_next_states} = checkTransitions(input, nil_next_states, repeated_transitions)
        cond do
          next_states == [] && nil_next_states == [] -> []
          next_states != [] && nil_next_states == [] ->
            analyzeInput(tl(input), transitions, [hd(next_states)], repeated_transitions) ++
            analyzeInput(tl(input), transitions, tl(next_states), repeated_transitions)
          next_states == [] && nil_next_states != [] ->
            analyzeInput(input, transitions, [hd(nil_next_states)], repeated_transitions) ++
            analyzeInput(input, transitions, tl(nil_next_states), repeated_transitions)
          true ->
            analyzeInput(tl(input), transitions, [hd(next_states)], repeated_transitions) ++
            analyzeInput(tl(input), transitions, tl(next_states), repeated_transitions) ++
            analyzeInput(input, transitions, [hd(nil_next_states)], repeated_transitions) ++
            analyzeInput(input, transitions, tl(nil_next_states), repeated_transitions)
        end
      length(input) <= 0 && current_state_array != [] -> current_state_array
      true -> []
    end
  end

  def automatonAcceptsInput(input, transitions, initial_state, accepting_states) do
    final_states = Enum.uniq(analyzeInput(String.split(input, "", trim: true), transitions, initial_state))
    Enum.any?(accepting_states, fn(acceptable_state) -> Enum.member?(final_states, acceptable_state) end)
  end
end
