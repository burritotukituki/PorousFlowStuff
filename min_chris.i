[Mesh]
  [mesh]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 25
    ny = 25
    xmin = 0
    xmax = 500
    ymin = -100
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
    scaling = 1E-6 # fluid enthalpy is roughly 1E6
  []
[]

[BCs]
  [left_head]
    type = FunctionDirichletBC
    variable = porepressure
    function = 3E5
    boundary = left
  []
  [right_head]
    type = FunctionDirichletBC
    variable = porepressure
    function = 2.5E5
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
    gravity = '0 0 0'
    boundary = right
  []
[]
[AuxVariables]
    [T_in_hot]
      initial_condition = 293
    []
[]

[DiracKernels]
[source_warm]
    type = PorousFlowPolyLineSink
    SumQuantityUO = source_warm
    fluxes = '-10'
    p_or_t_vals = '293'
    line_length = 10.0
    multiplying_var = T_in_hot
    point_file = inj.bh
    variable = temperature
[]
[source_fluid]
    type = PorousFlowPolyLineSink
    SumQuantityUO = source_fluid
    fluxes = -10
    p_or_t_vals = 0.0
    line_length = 10.0
    point_file = inj.bh
    variable = porepressure
[]
[]

[UserObjects]
    [source_warm]
      type = PorousFlowSumQuantity
    []
    [source_fluid]
      type = PorousFlowSumQuantity
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
  gravity = '0 0 0'
  fp = the_simple_fluid
[]

[Materials]
  [porosity_aquifer]
    type = PorousFlowPorosityConst
    porosity = 0.1
  []
  [biot_modulus]
    type = PorousFlowConstantBiotModulus
    solid_bulk_compliance = 1E-10
    fluid_bulk_modulus = 2E9
  []
  [permeability_aquifer]
    type = PorousFlowPermeabilityConst
    permeability = '1E-11 0 0   0 1E-11 0   0 0 1E-12'
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
 end_time = 15552000
 dt = 432000
 nl_abs_tol = 1E-8
 automatic_scaling = true
 compute_scaling_once = false
 line_search = none
[]


[Outputs]
  exodus = true
[]
