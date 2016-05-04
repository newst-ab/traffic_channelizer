require 'spec_helper'

module ChannelGrouping
  describe Source do
    describe '#direct?' do
      context 'when the url is present' do
        let(:url) { 'http://some-site.com' }

        it 'returns false' do
          expect(Source.new(url).direct?).to be false
        end
      end

      context 'when the url is a blank string' do
        let(:url) { '' }

        it 'returns true' do
          expect(Source.new(url).direct?).to be true
        end
      end

      context 'when the url is nil' do
        let(:url) { nil }

        it 'returns true' do
          expect(Source.new(url).direct?).to be true
        end
      end
    end

    describe '#host' do
      context 'when the url is present' do
        let(:url) { 'http://some-site.com/some/path' }

        it 'returns the host' do
          expect(Source.new(url).host).to eq 'some-site.com'
        end
      end

      context 'when the url is a blank string' do
        let(:url) { '' }

        it 'returns nil' do
          expect(Source.new(url).host).to be nil
        end
      end

      context 'when the url is invalid' do
        let(:url) { 'http|someinvalidurl?a|b' }

        it 'returns nil' do
          expect(Source.new(url).host).to be nil
        end
      end
    end

    describe '#search_engine?' do
      before do
        allow(YAML).to receive(:load_file).and_return(
          'search_engines' => ['search-engine\.com']
        )
      end

      context 'when the source host matches a search engine' do
        let(:url) { "http://#{host}/some-path?#{query_string}" }
        let(:host) { 'www.search-engine.com' }

        context 'and the query string contain the search query parameter' do
          let(:query_string) { 'q=some_search_query' }

          it 'returns true' do
            expect(Source.new(url).search_engine?).to be true
          end
        end
      end

      context 'when the source host does not match any search engine hosts' do
        let(:url) { 'http://www.not-a-search.com' }

        it 'returns false' do
          expect(Source.new(url).search_engine?).to be false
        end
      end

      context 'when the url is nil' do
        let(:url) { nil }

        it 'returns false' do
          expect(Source.new(url).search_engine?).to be false
        end
      end
    end

    describe '#social_network?' do
      before do
        allow(YAML).to receive(:load_file).and_return(
          'social_networks' => ['facebook\.com', 'twitter\.com']
        )
      end

      context 'when the source host matches one of the social networks' do
        let(:url) { 'http://www.facebook.com/path/to/profile' }

        it 'returns true' do
          expect(Source.new(url).social_network?).to be true
        end
      end

      context 'when the source host is not a social network' do
        let(:url) { 'http://www.antisocial.com' }

        it 'returns false' do
          expect(Source.new(url).social_network?).to be false
        end
      end

      context 'when the url is nil' do
        let(:url) { nil }

        it 'returns false' do
          expect(Source.new(url).social_network?).to be false
        end
      end
    end

    describe '.config' do
      it 'loads the config file' do
        expect(Source.config).to be_a Hash
      end
    end

    describe '.search_engines' do
      it 'has configuration for search engines' do
        expect(Source.config['search_engines']).not_to be_empty
      end
    end

    describe '.social_networks' do
      it 'has configuration for social networks' do
        expect(Source.config['social_networks']).not_to be_empty
      end
    end
  end
end