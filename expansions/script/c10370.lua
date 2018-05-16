--星符『重力一击』
function c10370.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c10370.atkcon)
	e1:SetTarget(c10370.tgtg)
	e1:SetOperation(c10370.activate)
	c:RegisterEffect(e1)
end
function c10370.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	local bc=Duel.GetAttacker()
	if not c then return false end
	if c and c:IsControler(bc:GetControler()) then return false end
	if c:IsControler(1-tp) then c=bc end
	e:SetLabelObject(c)
	return c and c:IsSetCard(0x200)
end
function c10370.tgfilter(c)
	return c:IsSetCard(0x2024) and c:IsAbleToGrave()
end
function c10370.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=0
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then num=1 end
	if bc and bc:IsControler(ac:GetControler()) then num=1 end
	if ac:IsControler(1-tp) then ac=bc end
	if chk==0 then return num==0 and ac and Duel.IsExistingMatchingCard(c10370.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	e:SetLabelObject(ac)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10370.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10370.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local ec=e:GetLabelObject()
		if ec:IsFaceup() and ec:IsRelateToBattle() then
			local tc=ec:GetBattleTarget()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
			e1:SetLabelObject(tc)
			e1:SetValue(c10370.val)
			ec:RegisterEffect(e1)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_CHANGE_DAMAGE)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetTargetRange(0,1)
			e4:SetValue(c10370.damval)
			e4:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e4,tp)
			local e5=e4:Clone()
			e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
			e5:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e5,tp)
		end
	end
end
function c10370.val(e,c)
	local ac=e:GetHandler()
	local tc=e:GetLabelObject()
	local num1=(ac:GetLevel()+ac:GetRank()+ac:GetLink())*300
	local num2=(tc:GetLevel()+tc:GetRank()+tc:GetLink())*300
	return num1+num2
end
function c10370.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end