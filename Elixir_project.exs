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
      if (Enum.at(hand, 4) - Enum.at(hand, 0) == 12) do
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
    hand1 = Enum.map(hand, fn(n) -> rem(n, 13) end)
    temp1 = Enum.frequencies(hand1)
    key_list = Map.keys(temp1)
    res = tkr(temp1, key_list, [])
    res = Enum.uniq(Enum.sort(res))
    if Enum.at(res,0) == 1 && Enum.at(res,1) == 4 do
      true
    else
      false
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

  def flush(hand) do
    hand = Enum.sort(hand)
    cond do
      Enum.at(hand, 0) > 0 && Enum.at(hand, 4) < 14 ->
        true
      Enum.at(hand, 0) > 13 && Enum.at(hand, 4) < 27 ->
        true
      Enum.at(hand, 0) > 26 && Enum.at(hand, 4) < 40 ->
        true
      Enum.at(hand, 0) > 39 && Enum.at(hand, 4) < 53 ->
        true
      true ->
        false
    end
  end

  def flushTie(hand1, hand2) do
    hand11 = Enum.map(hand1, fn(n) -> rem(n, 13) end)
    hand22 = Enum.map(hand2, fn(n) -> rem(n, 13) end)
    hand22 = divFixer(hand22, [])
    hand11 = divFixer(hand11, [])
    hand11 = Enum.sort(hand11)
    hand22 = Enum.sort(hand22)
    cond do
      List.last(hand11) > List.last(hand22) ->
        1
      List.last(hand11) < List.last(hand22) ->
        2
      true ->
        hand1 = Enum.sort(hand1)
        hand2 = Enum.sort(hand2)
        if Enum.at(hand1, 4) > Enum.at(hand2, 4) do
          1
        else
          2
        end
    end
  end

  def straight(hand) do
    hand11 = Enum.map(hand, fn(n) -> rem(n, 13) end)
    hand11 = divFixer(hand11, [])
    hand11 = Enum.sort(hand11)
    if Enum.at(hand11, 4) - Enum.at(hand11, 0) == 4 do
      true
    else
      false
    end
  end

  def straightTie(hand1, hand2) do
    hand11 = Enum.map(hand1, fn(n) -> rem(n, 13) end)
    hand11 = divFixer(hand11, [])
    hand11 = Enum.sort(hand11)
    hand22 = Enum.map(hand2, fn(n) -> rem(n, 13) end)
    hand22 = divFixer(hand22, [])
    hand22 = Enum.sort(hand22)
    cond do
      Enum.at(hand11, 4) > Enum.at(hand22, 4) ->
        1
      Enum.at(hand11, 4) < Enum.at(hand22, 4) ->
        2
      true ->
        hand1 = Enum.sort_by(hand1, fn(n) -> rem(n,13) end)
        hand2 = Enum.sort_by(hand2, fn(n) -> rem(n,13) end)
        if Enum.at(hand1, 4) > Enum.at(hand2, 4) do
          1
        else
          2
        end
    end
  end

  def threeKind(hand) do
    hand1 = Enum.map(hand, fn(n) -> rem(n, 13) end)
    temp1 = Enum.frequencies(hand1)
    key_list = Map.keys(temp1)
    res = tkr(temp1, key_list, [])
    res = Enum.uniq(Enum.sort(res))
    if Enum.at(res,0) == 1 && Enum.at(res,1) == 3 do
      true
    else
      false
    end
  end

  def tkr(_, [], res), do: res
  def tkr(map, list, res) do
    tkr(map, tl(list), res ++[map[hd(list)]])
  end

  def threeKindTie(hand1, hand2) do
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
    if res1 > res2 do
      1
    else
      2
    end
  end

  def twoPair(hand) do
    hand1 = Enum.map(hand, fn(n) -> rem(n, 13) end)
    temp1 = Enum.frequencies(hand1)
    key_list = Map.keys(temp1)
    res = tkr(temp1, key_list, [])
    res = Enum.sort(res)
    if Enum.at(res,0) == 1 && Enum.at(res,1) == 2  && Enum.at(res,2) == 2 do
      true
    else
      false
    end
  end

  def twoPairTie(hand1, hand2) do
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
    res1 = Enum.uniq(tieLoop(temp1, temp3, [], 2))
    res2 = Enum.uniq(tieLoop(temp2, temp3, [], 2))
    res1 = res1 -- res2
    res2 = res2 -- res1
    res1 = Enum.sort(res1)
    res2 = Enum.sort(res2)
    cond do
      length(res1) == 1 ->
        if res1> res2 do
          1
        else
          2
        end
      length(res1) == 2 ->
        if Enum.at(res1, 1)> Enum.at(res2, 1) do
          1
        else
          2
        end
      true ->
        res1 = Enum.uniq(tieLoop(temp1, temp3, [], 1))
        res2 = Enum.uniq(tieLoop(temp2, temp3, [], 1))
        cond do
          res1> res2 ->
            1
          res1 < res2 ->
            2
          true ->
            hand11 = Enum.sort(hand1)
            hand22 = Enum.sort(hand2)
            if Enum.at(hand11, 4) > Enum.at(hand22, 4) do
              1
            else
              2
            end
        end
    end
  end

  def pair(hand) do
    hand1 = Enum.map(hand, fn(n) -> rem(n, 13) end)
    temp1 = Enum.frequencies(hand1)
    key_list = Map.keys(temp1)
    res = tkr(temp1, key_list, [])
    res = Enum.sort(res)
    if Enum.at(res,0) == 1 && Enum.at(res,1) == 1  && Enum.at(res,2) == 1 && Enum.at(res,3) == 2 do
      true
    else
      false
    end
  end

  def pairTie(hand1, hand2) do
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
    res1 = Enum.uniq(tieLoop(temp1, temp3, [], 2))
    res2 = Enum.uniq(tieLoop(temp2, temp3, [], 2))
    cond do
      res1 > res2 ->
        1
      res2 > res1 ->
        2
      true ->
        res1 = Enum.uniq(tieLoop(temp1, temp3, [], 1))
        res2 = Enum.uniq(tieLoop(temp2, temp3, [], 1))
        res1 = res1 -- res2
        res2 = res2 -- res1
        cond do
          length(res1) > 1 ->
            if List.last(res1) > List.last(res2) do
              1
            else
              2
            end
          length(res1) ==1 ->
            if res1 > res2 do
              1
            else
              2
            end
          true ->
            res1 = Enum.uniq(tieLoop(temp1, temp3, [], 2))
            t1 = Enum.filter(hand1, fn(n) -> rem(n,13)==rem(List.last(res1), 13) end)
            t2 = Enum.filter(hand2, fn(n) -> rem(n,13)==rem(List.last(res1), 13) end)
            t1 = Enum.sort(t1)
            t2 = Enum.sort(t2)
            if List.last(t1) > List.last(t2) do
              1
            else
              2
            end
        end
    end
  end

  def highCard(hand1, hand2) do
    hand11 = Enum.sort(hand1)
    hand22 = Enum.sort(hand2)
    hand11 = Enum.map(hand11, fn(n) -> rem(n, 13) end)
    hand22 = Enum.map(hand22, fn(n) -> rem(n, 13) end)
    hand11 = Enum.sort(hand11)
    hand22 = Enum.sort(hand22)
    hand22 = divFixer(hand22, [])
    hand11 = divFixer(hand11, [])
    hand111 = hand11 -- hand22
    hand222 = hand22 -- hand11
    hand111 = Enum.sort(hand111)
    hand222 = Enum.sort(hand222)
    cond do
      length(hand111)!=0 ->
        if List.last(hand111) > List.last(hand222) do
          1
        else
          2
        end
      true->
        t1 = Enum.filter(hand1, fn(n) -> rem(n,13)==rem(List.last(hand11), 13) end)
        t2 = Enum.filter(hand2, fn(n) -> rem(n,13)==rem(List.last(hand11), 13) end)
        t1 = Enum.sort(t1)
        t2 = Enum.sort(t2)
        if List.last(t1) > List.last(t2) do
          1
        else
          2
        end
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

  def deal(list) do
    hand1 = getHand1(list, [])
    hand2 = getHand2(list, [])
    temp = layerOne(hand1, hand2)
    cond do
      temp != nil ->
        if temp == 1 do
          finalizer2(hand1, [])
        else
          finalizer2(hand2, [])
        end
      true ->
        temp = layerTwo(hand1, hand2)
        cond do
          temp != nil ->
            if temp == 1 do
              finalizer2(hand1, [])
            else
              finalizer2(hand2, [])
            end
          true ->
            temp = layerThree(hand1, hand2)
            cond do
              temp != nil ->
                if temp == 1 do
                  finalizer2(hand1, [])
                else
                  finalizer2(hand2, [])
                end
              true ->
                temp = layerFour(hand1, hand2)
                cond do
                  temp != nil ->
                    if temp == 1 do
                      finalizer2(hand1, [])
                    else
                      finalizer2(hand2, [])
                    end
                  true ->
                    if layerFive(hand1, hand2) == 1 do
                      finalizer2(hand1, [])
                    else
                      finalizer2(hand2, [])
                    end
                  end
                end
              end
    end

  end

  def layerOne(hand1, hand2) do
    temp1 = royalFlush(hand1)
    temp2 = royalFlush(hand2)
    cond do
      temp1 == true && temp2 == nil ->
        1
      temp2 == true && temp1 == nil ->
        2
      temp1 == true && temp2 == true ->
        temp3 = royalFlushTie(hand1, hand2)
        if temp3 == 1 do
          1
        else
          2
        end
      true ->
        temp1 = straightFlush(hand1, 13, 0, 0)
        temp2 = straightFlush(hand2, 13, 0, 0)
        cond do
          temp1 == true && temp2 == false ->
            1
          temp2 == true && temp1 == false ->
            2
          temp1 == true && temp2 == true ->
            temp3 = straightFlushTie(hand1, hand2)
            if temp3 == 1 do
              1
            else
              2
            end
          true ->
            nil
      end
    end
  end

  def layerTwo(hand1, hand2) do
    temp1 = fourKind(hand1)
    temp2 = fourKind(hand2)
    cond do
      temp1 == true && temp2 == nil ->
        1
      temp2 == true && temp1 == nil ->
        2
      temp1 == true && temp2 == true ->
        temp3 = fourKindTie(hand1, hand2)
        if temp3 == 1 do
          1
        else
          2
        end
      true ->
        temp1 = fullHouse(hand1)
        temp2 = fullHouse(hand2)
        cond do
          temp1 == true && temp2 == nil ->
            1
          temp2 == true && temp1 == nil ->
            2
          temp1 == true && temp2 == true ->
            temp3 = fullHouseTie(hand1, hand2)
            if temp3 == 1 do
              1
            else
              2
            end
          true ->
            nil
      end
    end
  end

  def layerFive(hand1, hand2) do
    temp1 = pair(hand1)
    temp2 = pair(hand2)
    cond do
      temp1 == true && temp2 == false ->
        1
      temp2 == true && temp1 == false ->
        2
      temp1 == true && temp2 == true ->
        temp3 = flushTie(hand1, hand2)
        if temp3 == 1 do
          1
        else
          2
        end
      true ->
        highCard(hand1, hand2)
    end
  end

  def layerFour(hand1, hand2) do
    temp1 = threeKind(hand1)
    temp2 = threeKind(hand2)
    cond do
      temp1 == true && temp2 == false ->
        1
      temp2 == true && temp1 == false ->
        2
      temp1 == true && temp2 == true ->
        temp3 = threeKindTie(hand1, hand2)
        if temp3 == 1 do
          1
        else
          2
        end
      true ->
        temp1 = twoPair(hand1)
        temp2 = twoPair(hand2)
        cond do
          temp1 == true && temp2 == false ->
            1
          temp2 == true && temp1 == false ->
            2
          temp1 == true && temp2 == true ->
            temp3 = twoPairTie(hand1, hand2)
            if temp3 == 1 do
              1
            else
              2
            end
          true ->
            nil
      end
    end
  end


  def layerThree(hand1, hand2) do
    temp1 = flush(hand1)
    temp2 = flush(hand2)
    cond do
      temp1 == true && temp2 == false ->
        1
      temp2 == true && temp1 == false ->
        2
      temp1 == true && temp2 == true ->
        temp3 = flushTie(hand1, hand2)
        if temp3 == 1 do
          1
        else
          2
        end
      true ->
        temp1 = straight(hand1)
        temp2 = straight(hand2)
        cond do
          temp1 == true && temp2 == false ->
            1
          temp2 == true && temp1 == false ->
            2
          temp1 == true && temp2 == true ->
            temp3 = straightTie(hand1, hand2)
            if temp3 == 1 do
              1
            else
              2
            end
          true ->
            nil
      end
    end
  end

  def finalizer(hand) do
    cond do
      hand >0 && hand < 14 ->
        "C"
      hand >13 && hand < 27 ->
        "D"
      hand >26 && hand < 40 ->
        "H"
      true ->
        "S"
    end
  end

  def finalizer2([], res), do: res
  def finalizer2(hand, res) do
    cond do
      rem(hd(hand), 13) == 11 ->
        finalizer2(tl(hand), res ++ ["J"<>finalizer(hd(hand))])
      rem(hd(hand), 13) == 12 ->
        finalizer2(tl(hand), res ++ ["Q"<>finalizer(hd(hand))])
      rem(hd(hand), 13) == 13 ->
        finalizer2(tl(hand), res ++ ["K"<>finalizer(hd(hand))])
      true->
        finalizer2(tl(hand), res ++ [to_string(rem(hd(hand), 13))<>finalizer(hd(hand))])
    end
  end

end
