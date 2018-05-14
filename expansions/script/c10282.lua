--梦符『二重结界』
function c10282.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_LVCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,31051)
	e1:SetCost(c10282.cost)
	e1:SetTarget(c10282.tg1)
	e1:SetOperation(c10282.op1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCountLimit(1)
	e2:SetTarget(c10282.tg2)
	e2:SetValue(c10282.con2)
	c:RegisterEffect(e2)
end
function c10282.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c10282.tfilter1_1(c,tp)
	return c:IsFaceup() and c:GetLevel()>0 and not (c:IsType(TYPE_NORMAL) and c:IsControler(1-tp))
end
function c10282.tfilter1_2(c,e,tp)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) and c:GetLevel()>0 and not (c:IsType(TYPE_NORMAL) and c:IsControler(1-tp))
end
function c10282.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c10282.tfilter1_1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	local num=Duel.GetMatchingGroupCount(c10282.tfilter1_2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10282.tfilter1_1,tp,LOCATION_MZONE,LOCATION_MZONE,1,num,nil,tp)
	local sg=g:Filter(Card.IsControler,nil,1-tp)
	Duel.HintSelection(g)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,sg,sg:GetCount(),0,0)
end
function c10282.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsFaceup,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			if tc:IsControler(tp) then
				local e1_1=Effect.CreateEffect(c)
				e1_1:SetType(EFFECT_TYPE_SINGLE)
				e1_1:SetCode(EFFECT_UPDATE_LEVEL)
				e1_1:SetValue(1)
				e1_1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_1)
			else
				local e1_2=Effect.CreateEffect(c)
				e1_2:SetType(EFFECT_TYPE_SINGLE)
				e1_2:SetCode(EFFECT_UPDATE_LEVEL)
				e1_2:SetValue(1)
				e1_2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_2)
				local e1_3=Effect.CreateEffect(c)
				e1_3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_CANNOT_DISABLE)
				e1_3:SetType(EFFECT_TYPE_SINGLE)
				e1_3:SetRange(LOCATION_ONFIELD)
				e1_3:SetCode(EFFECT_DISABLE)
				e1_3:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_3)
			end
			tc=g:GetNext()
		end
	end
end
function c10282.tg2(e,c)
	return c:IsSetCard(0x100)
end
function c10282.con2(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
