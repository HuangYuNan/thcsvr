--魂魄行者✿衍生物
function c20253.initial_effect(c)
	local argTable = {1}
	Nef.EnablePendulumAttributeSP(c,c20253.tpii,aux.TRUE,argTable)
	Nef.SetPendExTarget(c,c20253.pendfilter)
	--ud link limt
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c20253.splimit)
	c:RegisterEffect(e1,tp)
end
function c20253.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_LINK) and not c:IsRace(RACE_ZOMBIE)
end
function c20253.cfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsRace(RACE_ZOMBIE)
end
function c20253.tpii(c)
	return Duel.GetMatchingGroupCount(c20253.cfilter,c:GetControler(),LOCATION_MZONE,0,nil)
end
function c20253.pendfilter(c)
	local tp = c:GetControler()
	return Duel.GetMatchingGroup(aux.TRUE, tp, 0x30, 0, nil)
end
