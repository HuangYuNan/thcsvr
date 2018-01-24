 --红符「红色不夜城」
function c22123.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22123.target)
	e1:SetOperation(c22123.operation)
	c:RegisterEffect(e1)
end
--
function c22123.tfilter0(c)
	return c:IsSetCard(0x814) and c:IsFaceup()
end
function c22123.tfilter1(c)
	return c:GetSequence()>4 
end
function c22123.check1(c)
	return c:IsType(TYPE_MONSTER)
end
function c22123.check2(c,g1,g2,tp)
	return (g1:IsContains(c) and c:GetControler()==tp)
		or (g2:IsContains(c) and c:IsLocation(LOCATION_MZONE) and (c:GetControler()==tp or c:GetSequence()>4))
end
function c22123.check3(c,g1,g2,tp)
	return (g2:IsContains(c) and c:IsLocation(LOCATION_MZONE) and c:GetControler()==tp and not g1:IsContains(c))
		or (g1:IsContains(c) and c:IsLocation(LOCATION_MZONE) and c:GetControler()==tp)
end
function c22123.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c22123.tfilter0,tp,LOCATION_MZONE,0,nil)==1 end
	local gn=Group.CreateGroup()
	local tc=Duel.GetMatchingGroup(c22123.tfilter0,tp,LOCATION_MZONE,0,nil):GetFirst()
	local seq=tc:GetSequence()
	if seq>4 then
		local g1=tc:GetColumnGroup()
		local g2=Duel.GetMatchingGroup(c22123.tfilter1,tp,0,LOCATION_MZONE,0,nil)
		if g2:GetCount()>0 then
			g1:Merge(g2)
		end
		if g1:GetCount()>0 then
			gn=g1:Filter(c22123.check1,tc)
		end
	else
		if seq==1 or seq==3 then
			local g1=tc:GetColumnGroup()
			local g2=tc:GetColumnGroup(1,1)
			gn=g2:Filter(c22123.check2,tc,g1,g2,tp)
		else
			local g1=tc:GetColumnGroup()
			local g2=tc:GetColumnGroup(1,1)
			gn=g2:Filter(c22123.check3,tc,g1,g2,tp)
		end
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,gn,gn:GetCount(),0,0)
end
--
function c22123.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local gn=Group.CreateGroup()
	local tc=Duel.GetMatchingGroup(c22123.tfilter0,tp,LOCATION_MZONE,0,nil):GetFirst()
	local seq=tc:GetSequence()
	if seq>4 then
		local g1=tc:GetColumnGroup()
		local g2=Duel.GetMatchingGroup(c22123.tfilter1,tp,0,LOCATION_MZONE,0,nil)
		if g2:GetCount()>0 then
			g1:Merge(g2)
		end
		if g1:GetCount()>0 then
			gn=g1:Filter(c22123.check1,tc)
		end
	else
		if seq==1 or seq==3 then
			local g1=tc:GetColumnGroup()
			local g2=tc:GetColumnGroup(1,1)
			gn=g2:Filter(c22123.check2,tc,g1,g2,tp)
		else
			local g1=tc:GetColumnGroup()
			local g2=tc:GetColumnGroup(1,1)
			gn=g2:Filter(c22123.check3,tc,g1,g2,tp)
		end
	end
	if gn:GetCount()>0 and Duel.Destroy(gn,REASON_EFFECT)~=0 then
		local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if h<gn:GetCount() then
			Duel.Draw(tp,gn:GetCount()-h,REASON_EFFECT)
		end
	end
end
