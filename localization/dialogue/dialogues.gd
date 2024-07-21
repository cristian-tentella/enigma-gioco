extends Node


const dialogues: Dictionary = {
	"test": ["test_1", "test_2", "test_3"],
	"pickup_item_generic": ["pickup_item_generic"],
	"door_locked_basic_dialogue": ["door_locked_basic_dialogue_1"],
	"pickup_set_of_keys": ["pickup_set_of_keys_1", "pickup_set_of_keys_2"],
	#"add_polipetto_to_inventory":["add_polipetto_1", "add_polipetto_2"],
	
	#FIRST SCRIPTED MOVEMENT =======================================
	"first_dialogue_on_wake_up" : ["first_dialogue_on_wake_up_1", "first_dialogue_on_wake_up_2", "first_dialogue_on_wake_up_3", "first_dialogue_on_wake_up_4", "first_dialogue_on_wake_up_5", "first_dialogue_on_wake_up_6"],
	"second_dialogue_on_wake_up" : ["second_dialogue_on_wake_up_1", "second_dialogue_on_wake_up_2", "second_dialogue_on_wake_up_3", "second_dialogue_on_wake_up_4", "second_dialogue_on_wake_up_5", "second_dialogue_on_wake_up_6", "second_dialogue_on_wake_up_7", "second_dialogue_on_wake_up_8", "second_dialogue_on_wake_up_9", "second_dialogue_on_wake_up_10", "second_dialogue_on_wake_up_11", "second_dialogue_on_wake_up_12"],
	"third_dialogue_on_wake_up" : ["third_dialogue_on_wake_up_1", "third_dialogue_on_wake_up_2", "third_dialogue_on_wake_up_3", "third_dialogue_on_wake_up_4", "third_dialogue_on_wake_up_5", "third_dialogue_on_wake_up_6", "third_dialogue_on_wake_up_7", "third_dialogue_on_wake_up_8", "third_dialogue_on_wake_up_9", "third_dialogue_on_wake_up_10", "third_dialogue_on_wake_up_11", "third_dialogue_on_wake_up_12", "third_dialogue_on_wake_up_13", "third_dialogue_on_wake_up_14", "third_dialogue_on_wake_up_15", "third_dialogue_on_wake_up_16"],
	"fourth_dialogue_on_wake_up" : ["fourth_dialogue_on_wake_up_1", "fourth_dialogue_on_wake_up_2", "fourth_dialogue_on_wake_up_3", "fourth_dialogue_on_wake_up_4", "fourth_dialogue_on_wake_up_5", "fourth_dialogue_on_wake_up_6", "fourth_dialogue_on_wake_up_7", "fourth_dialogue_on_wake_up_8", "fourth_dialogue_on_wake_up_9", "fourth_dialogue_on_wake_up_10", "fourth_dialogue_on_wake_up_11", "fourth_dialogue_on_wake_up_12", "fourth_dialogue_on_wake_up_13", "fourth_dialogue_on_wake_up_14", "fourth_dialogue_on_wake_up_15", "fourth_dialogue_on_wake_up_16", "fourth_dialogue_on_wake_up_17", "fourth_dialogue_on_wake_up_18", "fourth_dialogue_on_wake_up_19", "fourth_dialogue_on_wake_up_20", "fourth_dialogue_on_wake_up_21", "fourth_dialogue_on_wake_up_22", "fourth_dialogue_on_wake_up_23", "fourth_dialogue_on_wake_up_24", "fourth_dialogue_on_wake_up_25", "fourth_dialogue_on_wake_up_26", "fourth_dialogue_on_wake_up_27", "fourth_dialogue_on_wake_up_28", "fourth_dialogue_on_wake_up_29", "fourth_dialogue_on_wake_up_30", "fourth_dialogue_on_wake_up_31", "fourth_dialogue_on_wake_up_32", "fourth_dialogue_on_wake_up_33", "fourth_dialogue_on_wake_up_34"],
	#=======================================
	
	#FIRST MINIGAME =======================================
	"first_open_minigame_combination": ["first_open_minigame_combination_1", "first_open_minigame_combination_2"],
	"first_minigame_combination_door_fail": ["first_minigame_combination_door_fail_1", "first_minigame_combination_door_fail_2"],
	"first_minigame_combination_short_win":["first_minigame_combination_short_win_1"],
	"dialogue_with_pi_poster": ["dialogue_with_pi_poster_1", "dialogue_with_pi_poster_2", "dialogue_with_pi_poster_3", "dialogue_with_pi_poster_4"],
	"actual_minigame_combination_first_dialogue": ["actual_minigame_combination_first_dialogue_1"],
	"combination_minigame_won": ["combination_minigame_won_1", "combination_minigame_won_2"],
	#=======================================
	
	#SECOND MINIGAME =======================================
	"memeory_first_dialogue":["memeory_first_dialogue_1", "memeory_first_dialogue_2", "memeory_first_dialogue_3", "memeory_first_dialogue_4",
							  "memeory_first_dialogue_5", "memeory_first_dialogue_6", "memeory_first_dialogue_7"],
	"memeory_retry":["memeory_retry_1", "memeory_retry_2"],
	"memeory_win":["memeory_win_1", "memeory_win_2", "memeory_win_3", "memeory_win_4"],
	"memeory_win_after_polipetto" : ["memeory_win_after_polipetto_1", "memeory_win_after_polipetto_2", "memeory_win_after_polipetto_3"],
	"memeory_lost":["memeory_lost_1", "memeory_lost_2"],
	#=======================================
	
	#THIRD MINIGAME =======================================
	"minigame_3_colors_mobile_bloccato":["minigame_3_colors_mobile_bloccato"],
	"minigame_3_won" : ["minigame_3_won_1", "minigame_3_won_2"],
	"minigame_3_lost": ["minigame_3_lost"],
	"minigame_3_after_plutonio": ["minigame_3_after_plutonio"],
	#=======================================
	
	#FOURTH MINIGAME =======================================
	"dialogo_monnezza": ["dialogo_monnezza_1", "dialogo_monnezza_2", "dialogo_monnezza_3"],
	"click_spada_laser_dialogo_minigame4": ["click_spada_laser_dialogo_minigame4_1", "click_spada_laser_dialogo_minigame4_2", 
			"click_spada_laser_dialogo_minigame4_3", "click_spada_laser_dialogo_minigame4_4", "click_spada_laser_dialogo_minigame4_5",
			"click_spada_laser_dialogo_minigame4_6", "click_spada_laser_dialogo_minigame4_7", "click_spada_laser_dialogo_minigame4_8",
			"click_spada_laser_dialogo_minigame4_9", "click_spada_laser_dialogo_minigame4_10"],
	"click_spada_laser_dialogo_minigame4_after": ["click_spada_laser_dialogo_minigame4_after"],
	"minigame_4_won": ["minigame_4_won_1", "minigame_4_won_2", "minigame_4_won_3", "minigame_4_won_4", "minigame_4_won_5"],
	"minigame_4_lost": ["minigame_4_lost"],
	"wrong_item_selected_minigame4": ["wrong_item_selected_minigame4"],
	"brucia_immondizia_inizio": ["brucia_immondizia_inizio"],
	"brucia_immondizia_fine": ["brucia_immondizia_fine"]
	#=======================================
}
