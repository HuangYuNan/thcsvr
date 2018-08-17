--过于危险的背景舞者✿尔子田里乃
function c32045.initial_effect(c)
c:EnableReviveLimit()
c32045.dfc_front_side=32018
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32045,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(0)
	e1:SetCountLimit(1,32045)
	e1:SetCost(c32045.cost1)
	e1:SetTarget(c32045.tg1)
	e1:SetOperation(c32045.op1)
	c:RegisterEffect(e1)
--
end
--
function c32045.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
--
function c32045.tfilter1_1(c)
	local lv=c:GetLevel()
	return c:GetLevel()<9 and c:IsAbleToGraveAsCost() and c:IsSetCard(0x410) and Duel.IsExistingMatchingCard(c32045.tfilter1_2,tp,0,LOCATION_MZONE,1,nil,lv)
end
function c32045.tfilter1_2(c,lv)
	local num=c:GetLevel()
	num=math.max(num,c:GetRank())
	num=math.max(num,c:GetLink())
	return num==lv and c:IsAbleToRemove()
end
function c32045.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c32045.tfilter1_1,tp,LOCATION_HAND,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c32045.tfilter1_1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
	local num=sg:GetFirst():GetLevel()
	local lg=Duel.GetMatchingGroup(c32045.tfilter1_2,tp,0,LOCATION_MZONE,nil,num)
	e:SetLabel(num)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,lg,lg:GetCount(),0,0)
end
--
function c32045.op1(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetLabel()
	local sg=Duel.GetMatchingGroup(c32045.tfilter1_2,tp,0,LOCATION_MZONE,nil,num)
	if sg:GetCount()<1 then return end
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
end
--
