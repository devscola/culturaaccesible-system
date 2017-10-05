require 'spec_helper_bdd'
require_relative 'test_support/exhibitions'
require_relative 'test_support/museum'
require_relative 'test_support/fixture_exhibitions'
require_relative 'test_support/fixture_museum'
require_relative 'test_support/exhibition_info'

feature 'Exhibitions' do
  before(:all) do
    Fixture::Exhibitions.pristine
    Fixture::Museum.pristine
  end

  context 'created' do
    before(:all) do
      Fixture::Exhibitions.pristine.complete_scenario
    end

    let(:current) { Page::Exhibitions.new }

    scenario 'displays form when edit' do
      exhibition = Fixture::Exhibitions::NAME
      current.click_exhibition(exhibition)
      current.click_edit

      expect(current.view_visible?).to be false
      expect(current.form_visible?).to be true
    end

    scenario 'displays editable info' do
      exhibition = Fixture::Exhibitions::NAME
      current.click_exhibition(exhibition)

      expect(current.view_visible?).to be true
      expect(current.has_edit_button?).to be true
    end

    scenario 'shows an image from added link' do
      exhibition = Fixture::Exhibitions::SECOND_EXHIBITION
      current = Page::Exhibitions.new
      current.click_exhibition(exhibition)

      expect(page).to have_xpath("//img[contains(@src,'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg')]" )
    end

    context 'item list' do
      scenario 'shows each room with plus button' do
        current = Page::Exhibitions.new
        current.toggle_list

        expect(current.room_have_plus_button?).to be true
      end

      scenario 'shows each sub-scene without plus button' do
        current = Page::Exhibitions.new
        current.toggle_list

        expect(current.subscene_has_plus_button?).to be false
      end

      scenario 'shows list sorted by creation date'  do
        current = Page::Exhibitions.new

        expect(current.second_exhibition_shown?).to be true
      end

      scenario 'links to create item page' do
        current = Page::Exhibitions.new
        current.has_css?('.exhibition-name', wait: 4, visible: true)
        current.click_plus_button

        expect(current.title(Fixture::Exhibitions::REDIRECTED_PAGE_TITLE)).to be true
      end
    end


    context 'sidebar' do
      scenario 'shows sidebar in all exhibitions pages' do
        current = Page::Exhibitions.new
        current.has_css?('.exhibition-name', wait: 4, visible: true)

        expect(current.has_sidebar?).to be true

        current.go_to_exhibition_info(Fixture::Exhibitions::NAME)
        current.has_css?('.exhibition-name', wait: 4, visible: true)

        expect(current.has_sidebar?).to be true
      end

      scenario 'shows a list of museums' do
        current = Page::Exhibitions.new

        expect(current.sidebar_has_museums?).to be true
      end

      scenario 'museum name links to museum detail' do
        current = Page::Exhibitions.new

        current.go_to_museum_info

        expect(current.title(Fixture::Museum::PAGE_TITLE)).to be true
      end

      scenario 'has new exhibition button' do
        current = Page::Exhibitions.new

        expect(current.has_new_exhibition_button?).to be true
      end

      scenario 'has new museum button' do
        current = Page::Exhibitions.new

        expect(current.has_new_museum_button?).to be true
      end

      scenario 'is in museum page' do
        current = Page::Museum.new

        expect(current.has_sidebar?).to be true
      end
    end

    context 'updates' do
      before(:all) do
        Fixture::Exhibitions.pristine.complete_scenario
      end

      scenario 'shows museum name saved in edit view' do
        exhibition = Fixture::Exhibitions::NAME
        museum = Fixture::Exhibitions::MUSEUM
        current = Page::Exhibitions.new
        current.go_to_exhibition_info(exhibition)

        expect(current.view_has_museum?(museum)).to be true
      end

      context 'translations' do

        scenario 'create one' do
          current = Page::Exhibitions.new
          current.click_add_exhibition
          current.fill_exhibition_mandatory_data
          current.fill_exhibition_translations
          current.save

          expect(current.content?('Nom Exhibicio')).to be true
          expect(current.content?('Descripció exhibició')).to be true
          expect(current.content?('Descripció curta exhibició')).to be true
        end

        scenario 'edit one' do
          exhibition_name = Fixture::Exhibitions::NAME
          other_exhibition_name = Fixture::Exhibitions::OTHER_NAME
          current.click_exhibition_name(exhibition_name)
          current.click_edit
          current.fill(Fixture::Exhibitions::NAME_FIELD, other_exhibition_name)
          current.update_translations
          current.save

          expect(current.name?(other_exhibition_name)).to be true
          expect(current.content?('Nom actualitzat')).to be true
          expect(current.content?('Descripció actualitzada')).to be true
          expect(current.content?('Descripció curta actualitzada')).to be true
        end
      end
    end

    context 'deletes' do
      before(:all) do
        Fixture::Exhibitions.pristine.complete_scenario
      end

      scenario 'doesnt show exhibition name in sidebar when is deleted' do
        first_exhibition = Fixture::Exhibitions::NAME
        second_exhibition = Fixture::Exhibitions::SECOND_EXHIBITION
        current = Page::Exhibitions.new

        current.click_exhibition_name(second_exhibition)
        current.click_delete_button
        current.accept_alert

        expect(current.content?(first_exhibition)).to be true
        expect(current.content?(second_exhibition)).to be false
      end
    end
  end

  context 'languages' do
    scenario 'displays toggle buttons for each language' do
      current = Page::Exhibitions.new

      expect(current.has_language_toggle_button?('en')).to be true
      expect(current.has_language_toggle_button?('cat')).to be true
    end

    scenario 'displays translation when toggle button is switched' do
      current = Page::Exhibitions.new
      current.active_language('english')

      expect(current.content?('Castellano')).to be true
      expect(current.content?('English')).to be true
      expect(current.content?('Valencià')).to be false
    end

    scenario 'displays all translation saved in view' do
      Fixture::Museum.complete_scenario
      current = Page::Exhibitions.new
      current.click_add_exhibition
      current.fill_exhibition_mandatory_data
      current.fill_exhibition_translations
      current.save

      expect(current.content?('Nombre Exhibición')).to be true
      expect(current.content?('Nom Exhibicio')).to be true
      expect(current.content?('Descripció exhibició')).to be true
      expect(current.content?('Descripció curta exhibició')).to be true
    end

  end
end
