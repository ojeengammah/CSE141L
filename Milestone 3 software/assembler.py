class Assembler:
    def __init__(self):
        # Placeholder dictionaries for immediate values and branch targets
        self.immediate_mapping = {
            0:    '000000',
            1:    '000001',
            2:    '000010',
            3:    '000011',
            4:    '000100',
            5:    '000101',
            6:    '000110',
            14:   '000111',
            16:   '001000',
            30:   '001001',
            31:   '001010',
            32:   '001011',
            33:   '001100',
            60:   '001101',
            91:   '001110',
            109:  '001111',
            142:  '010000',
            170:  '010001',
            204:  '010010',
            224:  '010011',
            225:  '010100',
            240:  '010101',
            247:  '010110',
            254:  '010111'
        }  
        self.branch_target_mapping = {
            '+2': '000', 
            '+3': '001',
            '+7': '010', 
            '+12': '011',
            'startloop' : '100',
            'startloop2' : '101',
            'startloop3' : '110',
            'startloop4' : '111'
        }  

    def assemble(self, input_file, output_file):
        with open(input_file, 'r') as file:
            assembly_code = file.readlines()

        machine_code = []
        for line in assembly_code:
            line = line.strip()
            if line:
                try:
                    machine_instruction = self.parse_instruction(line)
                    machine_code.append(machine_instruction)
                except Exception as e:
                    print(f'Error processing line: {line}')
                    print(f'Error details: {e}')
                    machine_code.append('001100000\terror')

        with open(output_file, 'w') as file:
            for idx, instruction in enumerate(machine_code):
                assembly_comment = f'// {assembly_code[idx].strip()}'
                file.write(f'{instruction}\t{assembly_comment}\n')

    def parse_instruction(self, instruction):
        parts = instruction.split()

        if parts[0] == 'inc' or parts[0] == 'dec':
            return self.parse_A_type(parts)
        elif parts[0] in ['shiftl', 'shiftr', 'and', 'or', 'xor', 'noop', 'par', 'add']:
            return self.parse_R_type(parts)
        elif parts[0] == 'bne':
            return self.parse_J_type(parts)
        elif parts[0] in ['load', 'store', 'movr']:
            return self.parse_I_type(parts)
        elif parts[0] in ['movi']:
            return self.parse_L_type(parts)
        else:
            raise ValueError(f'Invalid instruction: {parts[0]}')

    def parse_A_type(self, parts):
        opcode = '00000'
        register = self.register_to_binary(parts[1])
        funct = '0' if parts[0] == 'inc' else '1'
        return f'{opcode}{funct}{register}'

    def parse_R_type(self, parts):

        opcode = '00'
        funct = self.get_funct_code(parts[0])
        if (parts[0] == 'noop'):
            return f'{opcode}{funct}0000'
        
        register1 = self.register_to_binary(parts[1])
        register2 = self.register_to_binary(parts[2])
        if (register1[0] == '1' or register2[0] == '1'):
            raise ValueError(f'Invalid Register for Instruction: {parts[0]}')
        return f'{opcode}{funct}{register1[1:]}{register2[1:]}'

    def parse_J_type(self, parts):
        opcode = '10'
        register1 = self.register_to_binary(parts[1])
        register2 = self.register_to_binary(parts[2])
        if (register1[0] == '1' or register2[0] == '1'):
            raise ValueError(f'Invalid Register for Instruction: {parts[0]}')
        target = parts[3]
        branch_target = self.branch_target_mapping[target]  # Placeholder, replace with actual value
        return f'{opcode}{branch_target}{register1[1:]}{register2[1:]}'

        
    def parse_I_type(self, parts):
        
        opcode = None
        if parts[0] == 'movr':
            opcode  = '111'
        elif parts[0] == 'load':
            opcode = '010'
        elif parts[0] == 'store':
            opcode = '011' 
        register1 = self.register_to_binary(parts[1])
        register2 = self.register_to_binary(parts[2])
        return f'{opcode}{register1}{register2}'
            
    def parse_L_type(self, parts):
        opcode = '110'
        register1 = self.register_to_binary(parts[1])
        if (register1 != '011'):
            raise ValueError(f'movi can only be used with r3: {parts[0]}')
        try:
            immediate_value = self.immediate_mapping[int(parts[2])]
            return f'{opcode}{immediate_value}'
        except:
            raise ValueError(f'Immediate value not mapped: {parts[2]}')


    def register_to_binary(self, register):
        if register[1:].isdigit():
            return format(int(register[1:]), '03b')
        else:
            raise ValueError(f'Invalid register format: {register}')

    def get_funct_code(self, instruction):
        funct_mapping = {
            'shiftl': '000', 'shiftr': '001', 'and': '010', 'or': '011',
            'xor': '100', 'noop': '101', 'par': '110', 'add': '111',
            'bne': '00', 'load': '0', 'store': '1',
            'movi': '0', 'movr': '1'
        }
        return funct_mapping[instruction]
    


# Example usage
if __name__ == "__main__":
    assembler = Assembler()
    assembler.assemble('Programs/program1_assembly.txt', 'Programs/program1_machine_code.txt')
    assembler.assemble('Programs/program2_assembly.txt', 'Programs/program2_machine_code.txt')
    assembler.assemble('Programs/program3_assembly.txt', 'Programs/program3_machine_code.txt')
