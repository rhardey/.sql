CREATE OR REPLACE PACKAGE BODY debug_timer
IS

	TYPE debug_time_tabletype IS
		TABLE OF NUMBER INDEX BY BINARY_INTEGER;

	v_start_time	debug_time_tabletype;

	-- ################################################################################
	-- sets the time for a particular index
	-- ################################################################################
	PROCEDURE set_time(
		i_index		IN	NUMBER
	)
	IS
	BEGIN

		v_start_time(i_index) := DBMS_UTILITY.GET_TIME;

	END set_time;
	-- ################################################################################

	-- ################################################################################
	-- gets the elapsed time for a particular index since it was last set in 1/100ths of seconds
	-- ################################################################################
	FUNCTION get_elapsed_time(
		i_index		IN	NUMBER
	)
	RETURN NUMBER
	IS
	BEGIN

		IF v_start_time(i_index) IS NULL
		THEN

			RETURN NULL;

		ELSE
		
			RETURN DBMS_UTILITY.GET_TIME - v_start_time(i_index);

		END IF;

	END get_elapsed_time;
	-- ################################################################################

END debug_timer;
