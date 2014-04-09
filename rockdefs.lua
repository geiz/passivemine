local mine_img_folder = "mineimgs/"

local rockdefs = {
	{	name = "Poo", 
		start_hp = 2, curr_hp = 2,
		defense = 0, 
		dollar = 1, 
		image = mine_img_folder.."poo.jpg", 
		id = 1,},
	{	name = "Dried Dung", 
		start_hp = 50, curr_hp = 50,
		defense = 2, 	
		dollar = 10, 
		image = mine_img_folder.."drieddung.jpg", 
		id = 2,},
	{	name = "Dirt",
		start_hp = 500, curr_hp = 500,
		defense = 10, 
		dollar = 100, 
		image = mine_img_folder.."dirt.jpg", 
		id = 3},
	{	name = "Clay", 
		start_hp = 20000, curr_hp = 20000,
		defense = 25, 
		dollar = 3000, 
		image = mine_img_folder.."clay.jpg", 
		id = 4},
	{	name = "Rockfragments", 
		start_hp = 1000000, curr_hp = 1000000,
		defense = 100, 
		dollar = 40000, 
		image = mine_img_folder.."rockfragments.jpg", 
		id = 5},
	{	name = "Salt", 
		start_hp = 2500000, curr_hp = 2500000,
		defense = 500, 
		dollar = 100000, 
		image = mine_img_folder.."halite.jpg", 
		id = 6},
}

return rockdefs
