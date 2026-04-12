# assign_to_global has been removed.
# This function was a workaround to inject objects into the global environment
# from package code. The refactored architecture no longer needs it:
# functions now return values instead of modifying the global environment.
