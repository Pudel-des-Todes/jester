-- TODO: move following section to KCDFW upon proper testing and expansion
-- <move_to_kcdfw>

jester.disableQuest = function(quest)
	QuestSystem.DeactivateQuest(quest);
	kcdfw.logVerbose(jester, "Quest disabled: %s", quest);
end

jester.enableQuest = function(quest)
	QuestSystem.ActivateQuest(quest);
	kcdfw.logVerbose(jester, "Quest enabled: %s", quest);
end

jester.resetQuest = function(quest)
	QuestSystem.ResetQuest(quest);
	kcdfw.logVerbose(jester, "Quest reset: %s", quest);
end

jester.startQuest = function(quest)
	QuestSystem.StartQuest(quest);
	kcdfw.logVerbose(jester, "Quest started: %s", quest);
end

jester.startQuestObjective = function(quest, objective)
	QuestSystem.StartObjective(quest, objective);
	kcdfw.logVerbose(jester, "Quest objective started: %s, %u", quest, objective);
end

-- </move_to_kcdfw>




jester.cmdQuest = function(args)
	local enable = (args.enable or args.e);
	local disable = (args.disable or args.d);
	local reset = (args.reset or args.r);
	local start = (args.start or args.s);
	local objective = (args.objective or args.obj or args.o);
	local quest = (args.quest or args.q);


	if reset then
		if not objective then
			objective = 1
		end

		start = true;
	end

	local didSomething = false;

	if disable then
		jester.disableQuest(quest);
		didSomething = true;
	end

	if reset then
		jester.resetQuest(quest);
		didSomething = true;
	end

	if enable then
		jester.enableQuest(quest);
		didSomething = true;
	end

	if start then
		jester.startQuest(quest);
		didSomething = true;
	end

	if objective then
		jester.startQuestObjective(quest, objective);
		didSomething = true;
	end


	if didSomething then
		kcdfw.logInfo(jester, "Done.");
	else
		kcdfw.logWarning(jester, "No operation was executed.");
	end
end


kcdfw.registerCommand(
	"jester_quest",
	"jester.cmdQuest(cmdtab(%line))",
	"Quest system manipulation.",
	{
		e = "Enable the specified quest.",
		r = "Reset the specified quest.",
		d = "Disable the specified quest.",
		s = "Start the specified quest.",
		o = { value = "objective", description = "Start the given objective on the specified quest.", optional = true },
		q = { value = "quest", description = "Specify quest to act on." }
	}
);




jester.cmdQuestList = function(args)
	local filter = (args.filter or args.f);

	local res = kcdfw.findQuest(filter);
	for i, quest in ipairs(res) do
		kcdfw.logAlways(jester, "> %s", quest);
	end
end


kcdfw.registerCommand(
	"jester_quest_list",
	"jester.cmdQuestList(cmdtab(%line))",
	"Quest listing.",
	{
		f = { value = "pattern", description = "Filter to apply to the listing. Only entries containing <pattern> are listed.", optional = true }
	}
)
