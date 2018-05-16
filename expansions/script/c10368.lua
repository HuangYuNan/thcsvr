--天仪『太阳系仪』
function c10368.initial_effect(c)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e5)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c10368.sumcon)
	e1:SetOperation(c10368.sumsuc)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)  
	--atkremove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10368,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c10368.atcon)
	e3:SetOperation(c10368.atop)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10368,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c10368.condition)
	e4:SetTarget(c10368.target)
	e4:SetOperation(c10368.op)
	c:RegisterEffect(e4)
end
function c10368.cfilter(c)
	return c:IsSetCard(0x200)
end
function c10368.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10368.cfilter,1,nil)
end
function c10368.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c10368.efun)
end
function c10368.efun(e,ep,tp)
	return ep==tp
end
function c10368.atcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(tp) then
		e:SetLabelObject(a)
		return d:IsSetCard(0x200) and (a:IsRelateToBattle() or not a:IsReason(REASON_BATTLE))
	elseif a:IsControler(tp) then
		e:SetLabelObject(d)
		return a:IsSetCard(0x200) and (d:IsRelateToBattle() or not d:IsReason(REASON_BATTLE))
	end
	return false
end
function c10368.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
--
function c10368.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x2024) and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c10368.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToGrave()
end
function c10368.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10368.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,re:GetHandler():GetCode()) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK+LOCATION_REMOVED)   
end
function c10368.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10368.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,re:GetHandler():GetCode())
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
