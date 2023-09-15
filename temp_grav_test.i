[Mesh]
  [mesh]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 25
    ny = 5
    bias_y = 0.6
    xmin = 0
    xmax = 500
    ymin = -25
    ymax = 0
  []
[]

[GlobalParams]
  PorousFlowDictator = dictator
[]

[Variables]
  [porepressure]
  []
  [temperature]
    initial_condition = 288
    scaling = 1E-6
  []
[]

[ICs]
  [porepressure]
    type = FunctionIC
    variable = porepressure
    function = '1E4*(25 - y)'  # this is only approximately correct
  []
[]

[BCs]
  [left_head]
    type = FunctionDirichletBC
    variable = porepressure
    function = (5-y)*1E4
    boundary = left
  []
  [right_head]
    type = FunctionDirichletBC
    variable = porepressure
    function = (-y)*1E4
    boundary = right
  []
  [left_temp]
    type = DirichletBC
    variable = temperature
    value = 288
    boundary = left
  []
  [out_temp]
    type = PorousFlowOutflowBC
    flux_type = heat
    variable = temperature
    gravity = '0 -10 0'
    boundary = right
  []
[]

[FluidProperties]
  [the_simple_fluid]
    type = SimpleFluidProperties
    thermal_expansion = 2E-4
    bulk_modulus = 2E9
    viscosity = 1E-3
    density0 = 1000
    cv = 4000.0
    cp = 4000.0
  []
[]

[PorousFlowUnsaturated]
  porepressure = porepressure
  temperature = temperature
  coupling_type = ThermoHydro
  gravity = '0 -10 0'
  fp = the_simple_fluid
[]

[Materials]
  [porosity_aquifer]
    type = PorousFlowPorosityConst
    porosity = 0.1
  []
  [biot_modulus_both]
    type = PorousFlowConstantBiotModulus
    solid_bulk_compliance = 1E-10
    fluid_bulk_modulus = 2E9
  []
  [permeability_aquitard]
    type = PorousFlowPermeabilityConst
    permeability = '1E-10 0 0   0 1E-10 0   0 0 1E-10'
  []
  [thermal_expansion]
    type = PorousFlowConstantThermalExpansionCoefficient
    fluid_coefficient = 5E-6
    drained_coefficient = 2E-4
  []
  [thermal_conductivity]
    type = PorousFlowThermalConductivityIdeal
    dry_thermal_conductivity = '1 0 0  0 1 0  0 0 1'
  []
  [rock_heat]
    type = PorousFlowMatrixInternalEnergy
    density = 2500.0
    specific_heat_capacity = 1200.0
  []
[]

[Preconditioning]
  active = basic
  [basic]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = ' asm      lu           NONZERO                   2'
  []
[]

[Executioner]
  type = Transient
  solve_type = Newton
  end_time = 3e9
  nl_abs_tol = 1e-12
  nl_rel_tol = 1e-06
  steady_state_detection = true
  steady_state_tolerance = 1e-12
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e1
  []
[]

[Outputs]
  exodus = true
[]
