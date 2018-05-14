--星符『逃逸速度』
function c10369.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCondition(c10369.con1)
	e1:SetTarget(c10369.tg1)
	e1:SetOperation(c10369.op1)
	c:RegisterEffect(e1)   
end
--
function c10369.con1(e,tp,eg,ep,ev,re,r,rp)
	local num=0
	local ac=Duel.GetAttacker()
	local dc=Duel.GetAttackTarget()
	if dc then
		if ac:IsControler(dc:GetControler()) then num=1 end
	end
	if dc and dc:IsControler(tp) then ac=dc end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return num==0 and ac:IsSetCard(0x200)
end
--
function c10369.filter1(c,e,tp,ac)
	local atk=ac:GetTextAttack()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x200) and c:GetAttack()~=atk
end
function c10369.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=0
	local ac=Duel.GetAttacker()
	local dc=Duel.GetAttackTarget()
	if dc then
		if ac:IsControler(dc:GetControler()) then num=1 end
	end
	if dc and dc:IsControler(tp) then ac=dc end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return num==0 and ac:IsAbleToHand() and (ft>0 or ac:GetSequence()<5) and Duel.IsExistingMatchingCard(c10369.filter1,tp,LOCATION_DECK,0,1,nil,e,tp,ac) end
	e:SetLabelObject(ac)
	Duel.SetTargetCard(ac)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,ac,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
--
function c10369.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=e:GetLabelObject()
	if not ac:IsRelateToBattle() then return end
	if Duel.SendtoHand(ac,nil,2,REASON_EFFECT)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,c10369.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,ac)
		if tg:GetCount()<1 then return end
		local tc=tg:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_UPDATE_ATTACK)
			e1_1:SetRange(LOCATION_MZONE)
			e1_1:SetValue(-1000)
			e1_1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1_1,true)
			local e1_2=Effect.CreateEffect(c)
			e1_2:SetType(EFFECT_TYPE_SINGLE)
			e1_2:SetCode(EFFECT_EXTRA_ATTACK)
			e1_2:SetValue(1)
			e1_2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1_2,true)
			local e1_3=Effect.CreateEffect(c)
			e1_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1_3:SetCode(EVENT_PHASE+PHASE_END)
			e1_3:SetRange(LOCATION_MZONE)
			e1_3:SetCountLimit(1)
			e1_3:SetOperation(c10369.op1_3)
			e1_3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1_3,true)
			local e1_4=Effect.CreateEffect(c)
			e1_4:SetType(EFFECT_TYPE_FIELD)
			e1_4:SetCode(EFFECT_CHANGE_DAMAGE)
			e1_4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1_4:SetTargetRange(0,1)
			e1_4:SetValue(c10369.val1_4)
			e1_4:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1_4,tp)
			local e1_5=e1_4:Clone()
			e1_5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
			e1_5:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1_5,tp)
		end
	end
end
--
function c10369.op1_3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c10369.val1_4(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
--
