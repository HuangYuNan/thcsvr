--不思议的魔法少女✿芙兰朵露
function c19058.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c19058.fffilter,c19058.ffilter,true) 
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c19058.con1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c19058.val2)
	c:RegisterEffect(e2)
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(0,1)
	e5:SetTarget(c19058.tg5)
	c:RegisterEffect(e5)
--
	if not c19058.global_check then
		c19058.global_check=true
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAINING)
		e3:SetCondition(c19058.con3)
		e3:SetOperation(c19058.op3)
		Duel.RegisterEffect(e3,0)
	end
--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c19058.con4)
	e4:SetTarget(c19058.tg4)
	e4:SetOperation(c19058.op4)
	c:RegisterEffect(e4)
--
end
--
function c19058.ffilter(c)
	return c:IsFusionSetCard(0x300) and c:IsType(TYPE_RITUAL)
end
function c19058.fffilter(c)
	return c:IsFusionSetCard(0x815) and c:IsLevelAbove(6)
end
--
c19058.hana_mat={
c19058.ffilter,
c19058.fffilter,
}
--
function c19058.cfilter1(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end
function c19058.con1(e)
	return not Duel.IsExistingMatchingCard(c19058.cfilter1,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
--
function c19058.val2(e)
	local c=e:GetHandler()
	local t1=Duel.GetActivityCount(1-c:GetControler(),ACTIVITY_SPSUMMON)
	local t2=Duel.GetFlagEffect(1-c:GetControler(),19058)
	if t1>=t2 then return 0 else return t2-t1 end
end
--
function c19058.con3(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) 
		and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
--
function c19058.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,19058,RESET_PHASE+PHASE_END,0,1)
end
--
function c19058.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp
		and c:IsPreviousPosition(POS_FACEUP)
end
--
function c19058.tfilter4(c)
	return c:IsAbleToHand() 
		and (((c:IsCode(24235) or c:IsCode(24094653)) and c:IsType(TYPE_SPELL))
			or (c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL))
			or (c:IsSetCard(0x300) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)))
end
function c19058.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19058.tfilter4,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
--
function c19058.ofilter4_1(c)
	return c:IsSetCard(0x300) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c19058.ofilter4_2(c)
	return (c:IsCode(24235) or c:IsCode(24094653)) and c:IsType(TYPE_SPELL)
end
function c19058.ofilter4_3(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL)
end
function c19058.op4(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c19058.ofilter4_1,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c19058.ofilter4_2,tp,LOCATION_GRAVE,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c19058.ofilter4_2,tp,LOCATION_GRAVE,0,1,nil)
	if not (b1 or b2 or b3) then return end
	local gn=Group.CreateGroup()
	if b1 then
		if not (b2 or b3) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg1=Duel.SelectMatchingCard(tp,c19058.ofilter4_1,tp,LOCATION_GRAVE,0,1,1,nil)
			gn:Merge(sg1)
		else
			if Duel.SelectYesNo(tp,aux.Stringid(19058,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg1=Duel.SelectMatchingCard(tp,c19058.ofilter4_1,tp,LOCATION_GRAVE,0,1,1,nil)
				gn:Merge(sg1)
			end
		end
	end
	if b2 then
		if gn:GetCount()<1 and not b3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg2=Duel.SelectMatchingCard(tp,c19058.ofilter4_2,tp,LOCATION_GRAVE,0,1,1,nil)
			gn:Merge(sg2)
		else
			if Duel.SelectYesNo(tp,aux.Stringid(19058,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg2=Duel.SelectMatchingCard(tp,c19058.ofilter4_2,tp,LOCATION_GRAVE,0,1,1,nil)
				gn:Merge(sg2)
			end
		end
	end
	if b3 then
		if gn:GetCount()<1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg3=Duel.SelectMatchingCard(tp,c19058.ofilter4_3,tp,LOCATION_GRAVE,0,1,1,nil)
			gn:Merge(sg3)
		else
			if Duel.SelectYesNo(tp,aux.Stringid(19058,3)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg3=Duel.SelectMatchingCard(tp,c19058.ofilter4_3,tp,LOCATION_GRAVE,0,1,1,nil)
				gn:Merge(sg3)
			end
		end
	end
	if gn:GetCount()<0 then return end
	Duel.SendtoHand(gn,nil,REASON_EFFECT)
end
--
function c19058.tg5(e)
	local c=e:GetHandler()
	return Duel.GetActivityCount(1-c:GetControler(),ACTIVITY_SPSUMMON)>=Duel.GetFlagEffect(1-c:GetControler(),19058)
end
--
