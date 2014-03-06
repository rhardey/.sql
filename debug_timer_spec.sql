CREATE OR REPLACE PACKAGE debug_timer
IS

	-- ################################################################################
	-- sets the time for a particular index
	-- ################################################################################
	PROCEDURE set_time(
		i_index		IN	NUMBER
	);

	-- ################################################################################
	-- gets the time for a particular index since it was last set
	-- ################################################################################
	FUNCTION get_elapsed_time(
		i_index		IN	NUMBER
	)
	RETURN NUMBER;

END debug_timer;
