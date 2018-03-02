--红魔✿秘白之女仆长 十六夜咲夜
function c22075.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetCountLimit(1,22075)
	e1:SetCondition(c22075.con1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22075,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,22076)
	e2:SetTarget(c22075.tg2)
	e2:SetOperation(c22075.op2)
	c:RegisterEffect(e2)
end
function c22075.con1_1(c)
	return c:IsSetCard(0x814) and c:IsType(TYPE_MONSTER)
end
function c22075.con1_2(c)
	return c:IsSetCard(0x813) and c:IsFaceup()
end
function c22075.con1(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_ONFIELD,0,nil)<1 or Duel.IsExistingMatchingCard(c22075.cfilter1_1,tp,LOCATION_GRAVE,0,1,nil) or Duel.IsExistingMatchingCard(c22075.cfilter1_2,tp,LOCATION_ONFIELD,0,2,nil)
end
--
function c22075.tfilter2(c)
	return (c:IsSetCard(0x813) or c:GetOriginalCode()==(22100) or c:GetOriginalCode()==(22117)) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c22075.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22075.tfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c22075.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22075.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end


