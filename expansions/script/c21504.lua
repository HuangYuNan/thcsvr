--夜与虫的连结✿莉格露
function c21504.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c21504.matfilter,1)
end
function c21504.matfilter(c)
	return not c:IsLinkType(TYPE_TOKEN)
end
