module WorldFlags
	module Languages
		class << self		
 			attr_writer :en

			def en
				@en ||= {
					:ar => 'Argentinian Spanish',
					:br => 'Brazilian Portuguese',
					:po => 'Portuguese',
					:gr => 'Greek',
					:gb => 'British English',
					:us => 'US English',				
					:es => 'Spanish',
					:it => 'Italian',
					:nl => 'Dutch',
					:de => 'German',
					:dk => 'Danish',
					:se => 'Swedish',
					:sv => 'Swedish',
					:no => 'Norwegian',
					:nb => 'Norwegian',
					:fi => 'Finnish'
				}
			end

			def da
				{
					:gb => 'Engelsk',
					:us => 'Engelsk',				
					:es => 'Spansk',
					:de => 'Tysk',
					:dk => 'Dansk',
					:se => 'Svensk',
					:sv => 'Svensk',
					:no => 'Norsk'
				}
			end
			alias_method :dk, :da

			def se
				{
					:gb => 'Engelska',
					:us => 'Engelska',				
					:es => 'Spansk',
					:de => 'Tysk',
					:dk => 'Dansk',
					:se => 'Svenska',
					:sv => 'Svenska',
					:no => 'Norsk'
				}
			end
			alias_method :sv, :se

			def no
				{
					:gb => 'Engelsk',
					:us => 'Engelsk',				
					:es => 'Spansk',
					:de => 'Tysk',
					:dk => 'Dansk',
					:se => 'Svensk',
					:sb => 'Svensk',
					:no => 'Norsk'
				}
			end
			alias_method :nb, :no
		end
	end
end