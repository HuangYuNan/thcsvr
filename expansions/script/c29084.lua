--正义的伙伴✿鬼人正邪
function c29084.initial_effect(c)
c29084.dfc_front_side=29016
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c29084.con)
	e1:SetOperation(c29084.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29084,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetTarget(c29084.tg2)
	e2:SetOperation(c29084.op2)
	c:RegisterEffect(e2)
end
function c29084.con(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:GetControler()==1-tp and rc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER) and rc:IsAttribute(ATTRIBUTE_DARK)
end
function c29084.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.Destroy(rc,REASON_EFFECT)
end
function c29084.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetParam(1)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c29084.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
