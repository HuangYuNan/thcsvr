--春度与幸福的妖精☆莉莉妖✿
function c20261.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20261,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetTarget(c20261.sptg)
	e1:SetOperation(c20261.spop)
	c:RegisterEffect(e1)
	--!!!
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20261,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,20261)
	e3:SetTarget(c20261.target)
	e3:SetOperation(c20261.operation)
	c:RegisterEffect(e3)
end
function c20261.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20261.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,3000)
end
function c20261.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c20261.filter1,tp,LOCATION_DECK,0,1,2,nil)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
		Duel.Recover(tp,3000,REASON_EFFECT)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetOperation(c20261.lpop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c20261.lpop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-3000)
end
function c20261.filter1(c)
	return c:IsSetCard(0x123) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToGrave()
end
function c20261.filter(c)
	return c:IsSetCard(0x999)
end
function c20261.cfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c20261.filter2(c)
	return c:IsSetCard(0x999) and Duel.IsExistingMatchingCard(c20261.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c20261.filter3(c,e,tp)
	return c:IsSetCard(0x999) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20261.filter4(c)
	return c:IsSetCard(0x999) and c:IsAbleToDeck()
end
function c20261.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsSetCard(0x999) end
	if chk==0 then return Duel.IsExistingTarget(c20261.filter2,tp,LOCATION_GRAVE,0,1,nil) 
		or Duel.IsExistingTarget(c20261.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		or Duel.IsExistingTarget(c20261.filter4,tp,LOCATION_GRAVE,0,1,nil) end
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c20261.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	local t={}
	local p=1
	if Duel.IsExistingMatchingCard(c20261.filter2,tp,LOCATION_GRAVE,0,1,nil) then t[p]=aux.Stringid(20261,2) p=p+1 end
	if Duel.IsExistingMatchingCard(c20261.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) then t[p]=aux.Stringid(20261,3) p=p+1 end
	if Duel.IsExistingMatchingCard(c20261.filter4,tp,LOCATION_GRAVE,0,1,nil) then t[p]=aux.Stringid(20261,4) p=p+1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20261,5))
	local sel=Duel.SelectOption(tp,table.unpack(t))+1
	local opt=t[sel]-aux.Stringid(20261,2)
	if opt==1 then e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	elseif opt==2 then e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0) end
	e:SetLabel(opt)
end
function c20261.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local opt=e:GetLabel()
	local sg=nil
	if opt==0 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=Duel.SelectMatchingCard(tp,c20261.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.Overlay(sg:GetFirst(),Group.FromCards(tc))
		end
	elseif opt==1 then
		if e:GetHandler():IsRelateToEffect(e) then
			Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
