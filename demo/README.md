

Output values are resolved from the outputs_map object.
Each entry is a structured object with the following fields:
-	**value**
	The resolved Terraform value exposed to downstream modules or automation.
-	**description**
	Human readable documentation describing the purpose and semantics of the output.
-	**version**
	The current output schema version, used for compatibility tracking.
-	**since**
	The module version in which this output was first introduced.