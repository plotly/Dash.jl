using Aqua

# ideally we get both these tests to work, but:
# stale_deps is ignored to help transition from DashCoreComponents
# amiguities is ignored because they originate outside the package
Aqua.test_all(Dash; ambiguities=false, stale_deps=false)