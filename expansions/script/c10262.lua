--乐园的巫女服
function c10262.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10262.tg1)
	e1:SetOperation(c10262.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(50)
	c:RegisterEffect(e3)
--
end
--
c10262.check_list={
10226,
10229,
10238,
10240,
10242,
19039,
19040,
19045,
19047,
19050,
22040,
31040,
999003,
}
--
function c10262.tfilter1_1(c)
	return c:IsFaceup()
end
function c10262.tfilter1_2(c,e,tp)
	local num=0
	for i,v in pairs(c10262.check_list) do
		if c:IsCode(v) then num=1 end
	end
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:GetLevel()<8 and num==1
		and c.hana_mat and #c.hana_mat==2
		and Duel.IsExistingMatchingCard(c10262.tfilter1_2_1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,e,c)
		and not c:IsSetCard(0x100)
end
function c10262.tfilter1_2_1(c,e,fc)
	local checknum=0
	local t=fc.hana_mat
	if not t then return false end
	for i,f in pairs(t) do
		if f(c) then checknum=checknum+1 end
	end
	return (c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) or (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()))
		and ((checknum==1 and not c:IsSetCard(0x100)) or checknum==2)
		and c:IsAbleToRemove()
		and c:IsType(TYPE_MONSTER)
		and not c:IsImmuneToEffect(e)
end
function c10262.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local b1=Duel.IsExistingTarget(c10262.tfilter1_1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingMatchingCard(c10262.tfilter1_2,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0
	if chk==0 then return (b1 or b2) end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(10262,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(10262,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_EQUIP)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		Duel.SelectTarget(tp,c10262.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
--
function c10262.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		local tc=Duel.GetFirstTarget()
		if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.Equip(tp,e:GetHandler(),tc)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,c10262.tfilter1_2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if tg:GetCount()<1 then return end
		local tc=tg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=Duel.SelectMatchingCard(tp,c10262.tfilter1_2_1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,e,tc)
		if sg:GetCount()<1 then return end
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)<1 then return end
		if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)<1 then return end
		Duel.Equip(tp,c,tc)
	end
end
--
