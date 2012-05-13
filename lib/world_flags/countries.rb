module WorldFlags
	class Countries < Hashie::Mash
		def en
			@en ||= {
				:ar => 'Argentina',
				:br => 'Brazil',
				:gb => 'Great Britain',
				:us => 'United States',				
				:es => 'Spain',
				:gr => 'Greece',
				:it => 'Italy',
				:nl => 'Netherlands',
				:de => 'Germany',
				:dk => 'Denmark',
				:sv => 'Sweden',
				:no => 'Norway',
				:fi => 'Finland'
			}
		end

		def da
			@da ||= {
				:gb => 'England',
				:us => 'USA',				
				:es => 'Spanien',
				:de => 'Tyskland',
				:dk => 'Danmark',
				:sv => 'Sverige',
				:no => 'Norge',
			}
		end
		alias_method :dk, :da			

		def se
			{
				:gb => 'England',
				:us => 'USA',				
				:es => 'Spanien',
				:de => 'Tyskland',
				:dk => 'Danmark',
				:sv => 'Sverige',
				:no => 'Norge',
			}
		end
		alias_method :sv, :se

		def no
			{
				:gb => 'England',
				:us => 'USA',				
				:es => 'Spanien',
				:de => 'Tyskland',
				:dk => 'Danmark',
				:se => 'Sverige',
				:no => 'Norge'
			}
		end
		alias_method :nb, :no
	end
end