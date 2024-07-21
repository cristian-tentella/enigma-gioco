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
	"brucia_immondizia_fine": ["brucia_immondizia_fine"], 
	#=======================================
	
	#FIRST DIALOGUE WITH DANIEL DOWNSTAIRS =======================================
	"door_dialogue_with_daniel": ["door_dialogue_with_daniel_1", "door_dialogue_with_daniel_2", "door_dialogue_with_daniel_3", "door_dialogue_with_daniel_4", "door_dialogue_with_daniel_5", "door_dialogue_with_daniel_6", "door_dialogue_with_daniel_7", "door_dialogue_with_daniel_8", "door_dialogue_with_daniel_9", "door_dialogue_with_daniel_10", "door_dialogue_with_daniel_11", "door_dialogue_with_daniel_12", "door_dialogue_with_daniel_13", "door_dialogue_with_daniel_14", "door_dialogue_with_daniel_15", "door_dialogue_with_daniel_16", "door_dialogue_with_daniel_17", "door_dialogue_with_daniel_18", "door_dialogue_with_daniel_19", "door_dialogue_with_daniel_20", "door_dialogue_with_daniel_21", "door_dialogue_with_daniel_22", "door_dialogue_with_daniel_23", "door_dialogue_with_daniel_24", "door_dialogue_with_daniel_25", "door_dialogue_with_daniel_26"], 
	#=======================================
	
	#PICKUP GUEST LIST FROM KITCHEN TABLE =======================================
	"pickup_guest_list": ["pickup_guest_list_1", "pickup_guest_list_2", "pickup_guest_list_3", "pickup_guest_list_4", "pickup_guest_list_5", "pickup_guest_list_6", "pickup_guest_list_7", "pickup_guest_list_8"],
	#=======================================
	
	#ENDING DIALOGUE WITH DANIEL DOWNSTAIRS =======================================
	"ending_dialogue_with_daniel_door":["ending_dialogue_with_daniel_door_1", "ending_dialogue_with_daniel_door_2", "ending_dialogue_with_daniel_door_3", "ending_dialogue_with_daniel_door_4", "ending_dialogue_with_daniel_door_5", "ending_dialogue_with_daniel_door_6", "ending_dialogue_with_daniel_door_7", "ending_dialogue_with_daniel_door_8"], 
	#=======================================
	
	#INTERACTIONS WITH ITEMS AROUND THE HOUSE =======================================
	"bed_interaction": ["bed_interaction_1", "bed_interaction_2"],
	"fridge_interaction": ["fridge_interaction_1"],
	"christmas_tree_interaction": ["christmas_tree_interaction_1"],
	"toilet_interaction": ["toilet_interaction_1"],
	"plant_in_study_interaction": ["plant_in_study_interaction_1"]
	
	#=======================================
}
