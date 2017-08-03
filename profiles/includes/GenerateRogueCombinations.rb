Legendaries = {
    'Assassination' => {
        'head' => {'Head' => 'the_empty_crown,id=151815,bonus_id=3570'},
        #'neck' => {'Prydaz' => 'prydaz__xavarics_magnum_opus,id=132444,bonus_id=3570,enchant=mark_of_the_trained_soldier,gems=150mastery'},
        'shoulder' => {'Mantle' => 'mantle_of_the_master_assassin,id=144236,bonus_id=3570'},
        'waist' => {'Belt' => 'cinidaria_the_symbiote,id=133976,bonus_id=3570'},
        #'legs' => {'Legs' => 'will_of_valeera,id=137069,bonus_id=3570'},
        'feet' => {'Boots' => 'duskwalkers_footpads,id=137030,bonus_id=3570'},
                    #'CraftedBoots' => 'the_sentinels_eternal_refuge,id=146669,bonus_id=3570,gems=150mastery_150mastery_150mastery'},
        'wrists' => {'Bracers' => 'zoldyck_family_training_shackles,id=137098,bonus_id=3570'},
        'finger1' => {#'Sephuz' => 'sephuzs_secret,id=132452,bonus_id=3570,gems=150mastery,enchant=binding_of_mastery',
                    'Insignia' => 'insignia_of_ravenholdt,id=137049,bonus_id=3570,gems=150mastery,enchant=binding_of_mastery',
                    'Vigor' => 'soul_of_the_shadowblade,id=150936,bonus_id=3570,gems=150mastery,enchant=binding_of_mastery'},
        'trinket1' => {'KJBW' => 'kiljaedens_burning_wish,id=144259,bonus_id=3570'},
        'back' => {'Cloak' => 'the_dreadlords_deceit,id=137021,bonus_id=3570,enchant=binding_of_agility'},
    },
    'Outlaw' => {
        #'neck' => {'Prydaz' => 'prydaz__xavarics_magnum_opus,id=132444,bonus_id=3570,enchant=mark_of_the_hidden_satyr,gems=150versatility'},
        'shoulder' => {'Mantle' => 'mantle_of_the_master_assassin,id=144236,bonus_id=3570'},
        'waist' => {'Belt' => 'cinidaria_the_symbiote,id=133976,bonus_id=3570'},
        #'legs' => {'Legs' => 'will_of_valeera,id=137069,bonus_id=3570'},
        'feet' => {'Boots' => 'thraxis_tricksy_treads,id=137031,bonus_id=3570'},
                    #'CraftedBoots' => 'the_sentinels_eternal_refuge,id=146669,bonus_id=3570,gems=150versatility_150versatility_150versatility'},
        'wrists' => {'Bracers' => 'greenskins_waterlogged_wristcuffs,id=137099,bonus_id=3570'},
        'hands' => {'Hands' => 'shivarran_symmetry,id=141321,bonus_id=3570'},
        'finger1' => {#'Sephuz' => 'sephuzs_secret,id=132452,bonus_id=3570,gems=150versatility,enchant=binding_of_versatility',
                    'Insignia' => 'insignia_of_ravenholdt,id=137049,bonus_id=3570,gems=150versatility,enchant=binding_of_versatility',
                    'Vigor' => 'soul_of_the_shadowblade,id=150936,bonus_id=3570,gems=150versatility,enchant=binding_of_versatility'},
        'trinket1' => {'KJBW' => 'kiljaedens_burning_wish,id=144259,bonus_id=3570'},
        'back' => {'Cloak' => 'the_curse_of_restlessness,id=151817,bonus_id=3570,enchant=binding_of_agility}'},
    },
    'Subtlety' => {
        #'neck' => {'Prydaz' => 'prydaz__xavarics_magnum_opus,id=132444,bonus_id=3570,enchant=mark_of_the_trained_soldier,gems=150mastery'},
        'shoulder' => {'Mantle' => 'mantle_of_the_master_assassin,id=144236,bonus_id=3570'},
        'waist' => {'Belt' => 'cinidaria_the_symbiote,id=133976,bonus_id=3570'},
        #'legs' => {'Legs' => 'will_of_valeera,id=137069,bonus_id=3570'},
        'feet' => {'Boots' => 'shadow_satyrs_walk,id=137032,bonus_id=3570'},
                    #'CraftedBoots' => 'the_sentinels_eternal_refuge,id=146669,bonus_id=3570,gems=150mastery_150mastery_150mastery'},
        'wrists' => {'Bracers' => 'denial_of_the_halfgiants,id=137100,bonus_id=3570'},
        'hands' => {'Hands' => 'the_first_of_the_dead,id=151818,bonus_id=3570'},
        'finger1' => {#'Sephuz' => 'sephuzs_secret,id=132452,bonus_id=3570,gems=150mastery,enchant=binding_of_mastery',
                    'Insignia' => 'insignia_of_ravenholdt,id=137049,bonus_id=3570,gems=150mastery,enchant=binding_of_mastery',
                    'Vigor' => 'soul_of_the_shadowblade,id=150936,bonus_id=3570,gems=150mastery,enchant=binding_of_mastery'},
        'trinket1' => {'KJBW' => 'kiljaedens_burning_wish,id=144259,bonus_id=3570'},
        'back' => {'Cloak' => 'the_dreadlords_deceit,id=137021,bonus_id=3570,enchant=binding_of_agility'},
    }
}

#Duplicate second finger
Legendaries.keys.each do |spec|
    Legendaries[spec]['finger2'] = Legendaries[spec]['finger1']
end

# Yes, i'm a lazy copy paster for difficulties
Sets = {
    'T19M' => {
        'back' => 'doomblade_shadowwrap,id=138371,ilevel=905,enchant=binding_of_agility',
        'head' => 'doomblade_cowl,id=138332,ilevel=905',
        'legs' => 'doomblade_pants,id=138335,ilevel=905',
        'chest' => 'doomblade_tunic,id=138326,ilevel=905',
        'hands' => 'doomblade_gauntlets,id=138329,ilevel=905',
        'shoulder' => 'doomblade_spaulders,id=138338,ilevel=905',
    },
    'T20H' => {
        'chest' => 'fanged_slayers_chestguard,id=147169,ilevel=915',
        'hands' => 'fanged_slayers_handguards,id=147171,ilevel=915',
        'head' => 'fanged_slayers_helm,id=147172,ilevel=915',
        'back' => 'fanged_slayers_shroud,id=147170,ilevel=915,enchant=binding_of_agility',
        'legs' => 'fanged_slayers_legguards,id=147173,ilevel=915',
        'shoulder' => 'fanged_slayers_shoulderpads,id=147174,ilevel=915',
    },
    'T20M' => {
        'chest' => 'fanged_slayers_chestguard,id=147169,ilevel=930',
        'hands' => 'fanged_slayers_handguards,id=147171,ilevel=930',
        'head' => 'fanged_slayers_helm,id=147172,ilevel=930',
        'back' => 'fanged_slayers_shroud,id=147170,ilevel=930,enchant=binding_of_agility',
        'legs' => 'fanged_slayers_legguards,id=147173,ilevel=930',
        'shoulder' => 'fanged_slayers_shoulderpads,id=147174,ilevel=930',
    }
}

# Configurations of sets that will be exported
SetProfiles = [
    {'None' => 0},
    {'T19M' => 4},
    {'T19M' => 4, 'T20H' => 2},
    {'T19M' => 2, 'T20H' => 2},
    {'T19M' => 2, 'T20H' => 4},
    {'T20H' => 4},
    {'T20M' => 4},
    {'T20M' => 4, 'T19M' => 2},
    {'T20M' => 2, 'T19M' => 2},
    {'T20M' => 2, 'T19M' => 4},
]

def IsPossible(setProfile, legoSlots)
    totalPieces = setProfile.values.reduce(0, :+)
    return true if totalPieces <= 0
    availableSlots = []
    setProfile.each do |set, pieces|
        setSlots = Sets[set].keys
        setSlots -= legoSlots
        return false if setSlots.length < pieces
        availableSlots |= setSlots
    end
    return availableSlots.length >= totalPieces
end

def WriteSetPieces(file, setProfile, legoSlots)
    totalPieces = setProfile.values.reduce(0, :+)
    return if totalPieces <= 0
    filledSlots = []
    setProfile.each do |set, pieces|
        used = 0
        Sets[set].each do |slot, item|
            if !legoSlots.include?(slot) and !filledSlots.include?(slot)
                file.puts "#{slot}=#{item}"
                filledSlots.push slot
                used += 1
            end
            break if used == pieces
        end
    end
end

Legendaries.each do |spec, availableLegos|
    SetProfiles.each do |setProfile|
        setProfileName = setProfile.map{|set, pieces| pieces > 0 ? "#{set}#{pieces}" : set}.join('+')
        File.open("RogueCombinations/#{spec}_#{setProfileName}.simc", 'w') do |out|
            legoSlotCombinations = availableLegos.keys.combination(2).to_a
            legoSlotCombinations.each do |legoSlots|
                next if legoSlots.include?('finger2') and !legoSlots.include?('finger1')
                # Following loop branch is only relevant for duplicate slots like finger
                if availableLegos[legoSlots[0]] == availableLegos[legoSlots[1]]
                    availableLegos[legoSlots[0]].keys.combination(2).to_a.each do |legos|
                        next unless IsPossible(setProfile, legoSlots)
                        out.puts "copy=$(tbuild)_#{setProfileName}_#{legos[0]}_#{legos[1]},$(tbuild)_None"
                        WriteSetPieces(out, setProfile, legoSlots)
                        out.puts "#{legoSlots[0]}=#{availableLegos[legoSlots[0]][legos[0]]}"
                        out.puts "#{legoSlots[1]}=#{availableLegos[legoSlots[1]][legos[0]]}"
                        out.puts
                    end
                else
                    availableLegos[legoSlots[0]].each do |lego1, lego1input|
                        availableLegos[legoSlots[1]].each do |lego2, lego2input|
                            next unless IsPossible(setProfile, legoSlots)
                            out.puts "copy=$(tbuild)_#{setProfileName}_#{lego1}_#{lego2},$(tbuild)_None"
                            WriteSetPieces(out, setProfile, legoSlots)
                            out.puts "#{legoSlots[0]}=#{lego1input}"
                            out.puts "#{legoSlots[1]}=#{lego2input}"
                            out.puts
                        end
                    end
                end
            end
            # Add sets without legendaries
            if setProfile.values.reduce(0, :+) > 0 then
                out.puts "copy=$(tbuild)_#{setProfileName},$(tbuild)_None"
                WriteSetPieces(out, setProfile, [])
                out.puts
            end
        end
    end
end
