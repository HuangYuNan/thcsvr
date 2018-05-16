--夏彩紫巫女✿博丽灵梦
function c10240.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()  
	aux.AddFusionProcCodeFun(c,10260,aux.FilterBoolFunction(Card.IsFusionSetCard,0x100),1,true,true)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10240,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10240.drcon)
	e2:SetTarget(c10240.tdtg)
	e2:SetOperation(c10240.tdop)
	c:RegisterEffect(e2)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10240,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1)
	e1:SetCondition(c10240.drcon)
	e1:SetTarget(c10240.tdtg)
	e1:SetOperation(c10240.tdop)
	c:RegisterEffect(e1)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10240,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,10240)
	e4:SetCost(c10240.cost)
	e4:SetTarget(c10240.tg)
	e4:SetOperation(c10240.op)
	c:RegisterEffect(e4)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c10240.cons)
	e3:SetValue(c10240.atkval)
	c:RegisterEffect(e3) 
end
c10240.hana_mat={
aux.FilterBoolFunction(Card.IsFusionSetCard,0x100),
aux.FilterBoolFunction(Card.IsFusionCode,10260),
}
function c10240.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c10240.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,7,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,4,tp,LOCATION_EXTRA)
end
function c10240.tdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<7 then return end
	local cg=Duel.GetDecktopGroup(1-tp,7)
	if cg:GetCount()==7 then Duel.ConfirmCards(tp,cg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,4,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
--
function c10240.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c10240.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function c10240.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c10240.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10240.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
--
function c10240.atkval(e,c)
	return c:GetDefense()/-2
end
function c10240.cons(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
