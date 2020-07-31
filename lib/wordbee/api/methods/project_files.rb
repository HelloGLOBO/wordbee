# frozen_string_literal: true

module Wordbee
	module API

		module TranslationModes
			DO_NOT_TRANSLATE = 'TranslateNo'
			TRANSLATE_ONLINE = 'TranslateYesOnline'
			TRANSLATE_OFFLINE = 'TranslateYesOffline'
		end

		module TranslationParsers
			MSWORD = 'MSWORD'
			MSEXCEL = 'MSEXCEL'
			MSPPT = 'MSPPT'
			HTML = 'HTML'
			ASPX = 'ASPX'
			XML = 'XML'
			RESX = 'RESX'
			CODE = 'CODE'
			CSL = 'CSL'
			INDESIGN = 'INDESIGN'
			RTF = 'RTF'
			ODFTEXT = 'ODFTEXT'
			PHOTOSHOP = 'PHOTOSHOP'
			POT = 'POT'
		end

		module Methods
			module ProjectFiles

				def files
					FilesContext.new self
				end
			end
		end
	end
end

class ProjectsContext < MethodContext
	include Wordbee::API::Methods::ProjectFiles
end

class FilesContext < MethodContext

	attr_reader :project_context


	def initialize(project_context)
		super project_context.context
		@project_context = project_context
	end


	def upload(file, file_name: self.client.name_for_file(file), locale: 'en', overwrite: true)
		data = {
				name: file_name,
				overwrite: overwrite,
		}
		file = self.client.file_for_upload(file)
		self.client.request("#{@project_context.path}/files/#{locale}/file", method: 'POST', params: {name: file_name}, data: data.merge(file: file), file_upload: true)
	end

	def set_translation_mode(mode, file_name, locale: 'en', parser: nil, parser_config: nil, included_target: nil, reference: nil, version: nil, version_date: nil)
		data = {
				name: file_name,
				newmode: mode,
		}

		data[:parser] = parser if parser
		data[:parserconfig] = parser_config if parser_config
		data[:includedtarget] = included_target if included_target
		data[:reference] = reference if reference
		data[:version] = version if version
		data[:versiondate] = version_date if version_date

		self.client.request("#{@project_context.path}/files/#{locale}/file/translation", method: 'PUT', params: {name: file_name},  data: data.to_json)
	end

	private

	def project_id
		@project_context.project_id
	end

end

