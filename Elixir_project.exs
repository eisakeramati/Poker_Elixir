defmodule Poker do
  def getHand1([], output), do: output
  def getHand1([arg | args], output) do
      output = output ++ [arg]
      getHand1(tl(args), output)
  end
  def getHand2([], output), do: output
  def getHand2(arg, output) do
      arg = arg -- [hd(arg)]
      output = output ++ [hd(arg)]
      getHand2(tl(arg), output)
  end

  def royalFlush(hand) do
      hand = Enum.sort(hand)
      if (Enum.at(hand, 4) - Enum.at(hand, 4) == 12) do
        if rem((Enum.at(hand, 4)), 13) == 0 do
          if rem((Enum.at(hand, 3)), 13) == 12 do
            if rem((Enum.at(hand, 2)), 13) == 11 do
              if rem((Enum.at(hand, 1)), 13) == 10 do
                if rem((Enum.at(hand, 0)), 13) == 1 do
                  true
                end
              end
            end
          end
        end
      end
    end

  def royalFlushTie(hand1, hand2) do
    if Enum.at(hand1, 4) > Enum.at(hand2, 4) do
      1
    else
      2
    end
  end

  def straightFlushTie(hand1, hand2) do
    hand1 = Enum.sort(hand1)
    hand2 = Enum.sort(hand2)
    if rem(Enum.at(hand1, 4), 13) == rem(Enum.at(hand2, 4), 13) do
      if Enum.at(hand1, 4) > Enum.at(hand2, 4) do
        1
      else
        2
      end
    end
    if rem(Enum.at(hand1, 4), 13) > rem(Enum.at(hand2, 4), 13) do
      1
    else
      2
    end
  end

  def straightFlush(_, _, _, 4), do: false
  def straightFlush(hand, start1, start2, count) do
      hand = Enum.sort(hand)
      if Enum.at(hand, 4)<start1 && Enum.at(hand, 0) > start2 && (Enum.at(hand, 4) - Enum.at(hand, 0)) == 4 do
        true
      else
        straightFlush(hand, start1+13, start2+13, count + 1)
      end
  end

  def fullHouse(hand) do
    if length(Enum.uniq_by(hand, fn(n) -> rem(n, 13) end)) == 2 do
      true
    end
  end

  def fullHouseTie(hand1, hand2) do
    hand11 = Enum.sort(hand1)
    hand22 = Enum.sort(hand2)
    hand11 = Enum.map(hand11, fn(n) -> rem(n, 13) end)
    hand22 = Enum.map(hand22, fn(n) -> rem(n, 13) end)
    hand11 = Enum.sort(hand11)
    hand22 = Enum.sort(hand22)
    hand22 = divFixer(hand22, [])
    hand11 = divFixer(hand11, [])
    temp1 = Enum.frequencies(hand11)
    temp2 = Enum.frequencies(hand22)
    temp3 =  Map.keys(temp1) ++ Map.keys(temp2)
    res1 = Enum.uniq(tieLoop(temp1, temp3, [], 3))
    res2 = Enum.uniq(tieLoop(temp2, temp3, [], 3))
    cond do
      res1 > res2 ->
        1
      res2 > res1 ->
        2
    end
  end

  def fourKind(hand) do
    hand = Enum.sort(hand)
    temp1 = Enum.uniq_by(hand, fn(n) -> rem(n, 13) end)
    temp2 = Enum.map(hand, fn(n) -> rem(n, 13) end)
    temp2 = repetitionDeleter(temp2, Enum.at(temp1, 0), [])
    if length(temp2) == 4 || length(temp2) == 1 do
      true
    end
  end

  def fourKindTie(hand1, hand2) do
    hand11 = Enum.sort(hand1)
    hand22 = Enum.sort(hand2)
    hand11 = Enum.map(hand11, fn(n) -> rem(n, 13) end)
    hand22 = Enum.map(hand22, fn(n) -> rem(n, 13) end)
    hand11 = Enum.sort(hand11)
    hand22 = Enum.sort(hand22)
    hand22 = divFixer(hand22, [])
    hand11 = divFixer(hand11, [])
    temp1 = Enum.frequencies(hand11)
    temp2 = Enum.frequencies(hand22)
    temp3 =  Map.keys(temp1) ++ Map.keys(temp2)
    res1 = Enum.uniq(tieLoop(temp1, temp3, [], 4))
    res2 = Enum.uniq(tieLoop(temp2, temp3, [], 4))
    if res1 > res2 do
      1
    else
      2
    end
  end

  def repetitionDeleter([], _, out), do: out
  def repetitionDeleter(hand, elem, out) do
    if (hd(hand) == elem) do
      repetitionDeleter(tl(hand), elem, out)
    else
      repetitionDeleter(tl(hand), elem, out ++ [hd(hand)])
    end
  end

  def divFixer([], out), do: out
  def divFixer(hand, out) do
    if hd(hand) < 2 do
      divFixer(tl(hand), out ++ [hd(hand) + 13])
    else
      divFixer(tl(hand), out ++ [hd(hand)])
    end
  end

  def tieLoop(_, [], res,_), do: res
  def tieLoop(map1, keys, res, num) do
    if map1[hd(keys)] == num do
      tieLoop(map1, tl(keys), res ++ [hd(keys)], num)
    else
      tieLoop(map1, tl(keys), res, num)
    end
  end

end
