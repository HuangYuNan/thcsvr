--四季隐星-危险的背景舞者✿丁礼田舞
function c32015.initial_effect(c)
c32015.dfc_front_side=32042
--
	aux.EnablePendulumAttribute(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32015,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c32015.con1)
	e1:SetTarget(c32015.tg1)
	e1:SetOperation(c32015.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(32015)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(32015,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c32015.tg3)
	e3:SetOperation(c32015.op3)
	c:RegisterEffect(e3)
--
end
--
function c32015.cfilter1(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c32015.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c32015.cfilter1,1,nil,tp)
end
--
function c32015.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
--
function c32015.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return end
	Duel.ConfirmDecktop(tp,1)
	local tg=Duel.GetDecktopGroup(tp,1)
	local tc=tg:GetFirst()
	if tc:IsSetCard(0x410) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	else
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
	end
end
--

function c32015.tfilter3(c,e,tp)
	return c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function c32015.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c32015.tfilter3,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
--
function c32015.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c32015.tfilter3,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if sg:GetCount()<1 then return end
	Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
end
--
