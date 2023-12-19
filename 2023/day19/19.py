from copy import deepcopy
class Part:
    def __init__(self, x, m, a, s):
        self.x = x
        self.m = m
        self.a = a
        self.s = s

    @staticmethod
    def parse(input):
        x, m, a, s = input[1:-1].split(",")
        x = int(x.split("=")[1])
        m = int(m.split("=")[1])
        a = int(a.split("=")[1])
        s = int(s.split("=")[1])
        return Part(x, m, a, s)
    
    def sum(self):
        return self.x + self.m + self.a + self.s
    
    def __add__(self, other):
        return Part(self.x + other.x, self.m + other.m, self.a + other.a, self.s + other.s)
    
    def __repr__(self):
        return f"Part({self.x}, {self.m}, {self.a}, {self.s})"
    
    def __getitem__(self, key):
        return getattr(self, key)
    

class Rule:
    def __init__(self, condition, condition_str, action):
        self.condition = condition
        self.condition_str = condition_str
        self.action = action

    @staticmethod
    def parse(input):
        if ":" in input:
            condition_str, action = input.split(":")
            if "<" in condition_str:
                condition = condition_str.split("<")
                condition_fn = lambda x: x[condition[0]] < int(condition[1])
            elif ">" in condition_str:
                condition = condition_str.split(">")
                condition_fn = lambda x: x[condition[0]] > int(condition[1])
        else:
            condition_fn = lambda x: True
            action = input
            condition_str = "True"
        return Rule(condition_fn, condition_str, action)

    def __repr__(self):
        return f"Rule({self.condition_str}, {self.action})"



class Workflow:
    def __init__(self, name, rules):
        self.name = name
        self.rules = rules

    @staticmethod
    def parse(input):
        name, workflow = input.split("{")
        workflow = workflow[:-1]
        rules = [Rule.parse(rule) for rule in workflow.split(",")]
        return Workflow(name, rules)
    
    def evaluate(self, part):
        for rule in self.rules:
            if rule.condition(part):
                return rule.action
        return None
    
    def __repr__(self):
        return f"Workflow({self.name}, {self.rules})"

def parse_input(input):
    workflows, parts = input.split("\n\n")
    parts = [Part.parse(part) for part in parts.splitlines()]
    workflows = [Workflow.parse(workflow) for workflow in workflows.splitlines()]
    workflows = {workflow.name: workflow for workflow in workflows}
    return workflows, parts

def count_accepted_parts(workflows, parts):
    accepted_parts = []
    for part in parts:
        workflow = workflows["in"]
        action = workflow.evaluate(part)
        while action != "R" and action != "A":
            workflow = workflows[action]
            action = workflow.evaluate(part)
            if action == "A":
                accepted_parts.append(part)
    return sum([part.sum() for part in accepted_parts])

def count_range_combos(ranges):
    count = 1
    for range in ranges.values():
        count *= range[1] - range[0] + 1
    return count

def count_distinct_combos(workflows, current_workflow_name, current_ranges = {
    "x": (1, 4000),
    "m": (1, 4000),
    "a": (1, 4000),
    "s": (1, 4000)
}):
    if current_workflow_name == "A":
        return count_range_combos(current_ranges)
    elif current_workflow_name == "R":
        return 0
    
    current_workflow = workflows[current_workflow_name]
    total = 0

    for rule in current_workflow.rules:
        if "<" in rule.condition_str or ">" in rule.condition_str:
            sign = "<" if "<" in rule.condition_str else ">"
            condition = rule.condition_str.split(sign)
            letter, val = condition[0], int(condition[1])
            low, high = current_ranges[letter]
            new_ranges = current_ranges.copy()
            if sign == "<":
                if low < val:
                    new_ranges[letter] = (low, val - 1)
                    total += count_distinct_combos(workflows, rule.action, new_ranges)
                current_ranges[letter] = (max(low, val), high)
            else:
                if high > val:
                    new_ranges[letter] = (val + 1, high)
                    total += count_distinct_combos(workflows, rule.action, new_ranges)
                current_ranges[letter] = (low, min(high, val))
    total += count_distinct_combos(workflows, rule.action, current_ranges)
    return total

def solve(input):
    workflows, parts = parse_input(input)
    part_1 = count_accepted_parts(workflows, parts)
    part_2 = count_distinct_combos(workflows, "in")
    return part_1, part_2

part_1, part_2 = solve(open("19.in").read())
print("Part 1:", part_1)
print("Part 2:", part_2)