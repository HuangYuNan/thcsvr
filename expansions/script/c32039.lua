--常夜之神✿爱塔妮缇拉尔瓦
function c32039.initial_effect(c)
c32039.dfc_front_side=32001
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32039,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE+CATEGORY_LVCHANGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c32039.con1)
	e1:SetTarget(c32039.tg1)
	e1:SetOperation(c32039.op1)
	c:RegisterEffect(e1)
--
end
--
function c32039.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW 
end
--
function c32039.tfilter1(c,e,tp)
	return c:IsAbleToHand() and ((c:IsType(TYPE_MONSTER) and c:IsRace(RACE_INSECT) and c:GetLevel()<6) or (c:IsSetCard(0x522a)))
end
function c32039.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32039.tfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c32039.ofilter1_1(c)
	return c:IsAbleToRemove() and c:GetLevel()<1
end
function c32039.ofilter1_3(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c32039.op1(e,tp,eg,ep,ev,re,r,rp)
--
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c32039.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()<1 then return end
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)<1 then return end
--
	local tc=sg:GetFirst()
	if tc:IsPublic() then return end
	local c=e:GetHandler()
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_PUBLIC)
	e1_1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1_1)
--
	local b1=Duel.IsExistingMatchingCard(c32039.ofilter1_1,tp,0,LOCATION_MZONE,1,nil) and tc:GetLevel()>1
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
	local b3=Duel.IsExistingMatchingCard(c32039.ofilter1_3,tp,0,LOCATION_MZONE,1,nil)
	if not (b1 or b2 or b3) then return end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(32039,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(32039,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(32039,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
--
	if sel==1 then
		local e1_4=Effect.CreateEffect(c)
		e1_4:SetType(EFFECT_TYPE_SINGLE)
		e1_4:SetCode(EFFECT_UPDATE_LEVEL)
		e1_4:SetValue(-1)
		e1_4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc:RegisterEffect(e1_4)
		local sg=Duel.GetMatchingGroup(c32039.ofilter1_1,tp,0,LOCATION_MZONE,1,nil)
		if sg:GetCount()>0 then return end
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
--
	elseif sel==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)<1 then return end
		local e1_5=Effect.CreateEffect(c)
		e1_5:SetType(EFFECT_TYPE_SINGLE)
		e1_5:SetCode(EFFECT_SET_DEFENSE)
		e1_5:SetValue(tc:GetDefense()*3)
		e1_5:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1_5)
--
	else
		local sg=Duel.GetMatchingGroup(c32039.ofilter1_3,tp,0,LOCATION_MZONE,1,nil)
		if sg:GetCount()<1 then return end
		Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
--
	end
end
