gates = []
initial_values = {}
with open('24_swap.in', 'r') as f:
	for line in f:
		line = line.strip()
		if not line:
			continue
		
		if ':' in line:
			wire, value = line.split(':')
			initial_values[wire.strip()] = value.strip()
		else:
			inputs, output = line.split('->')
			gate_type = 'AND' if 'AND' in inputs else 'XOR' if 'XOR' in inputs else 'OR'
			in1, in2 = inputs.replace('AND', '').replace('XOR', '').replace('OR', '').split()
			gates.append((in1.strip(), in2.strip(), gate_type, output.strip()))

dot = ['digraph circuit {']
dot.append('\trankdir=LR;')

for wire, value in initial_values.items():
	dot.append(f'\t{wire} [label="{wire}={value}"];')

for in1, in2, gate_type, output in gates:
	gate_name = f"{in1}_{in2}_{gate_type}"
	dot.append(f'\t{gate_name} [label="{gate_type}"];')
	dot.append(f'\t{in1} -> {gate_name};')
	dot.append(f'\t{in2} -> {gate_name};')
	dot.append(f'\t{gate_name} -> {output};')

dot.append('}')

with open('circuit.dot', 'w') as f:
	f.write('\n'.join(dot))

