require 'rails_helper'

RSpec.describe User,"Userモデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
   context "保存できない場合" do
      
      it "名前が30文字以上" do
        expect(build(:user, :too_long_name)).to_not be_valid
      end

      it "名前が3文字未満" do
        expect(build(:user, :too_short_name)).to_not be_valid
      end

      it "名前が空白" do
        expect(build(:user, :no_name)).to_not be_valid
      end

      it "名前が他者と重複" do
        create(:user, :same_name)
        expect(build(:user, :same_name)).to_not be_valid
      end      

      it "メールアドレスが空白" do
        expect(build(:user, :no_email)).to_not be_valid
      end

      it "メールアドレスのフォーマットが違う（@がない）" do
        expect(build(:user, :wrong_email_format1)).to_not be_valid
      end

      it "メールアドレスのフォーマットが違う（.がない）" do
        expect(build(:user, :wrong_email_format2)).to_not be_valid
      end

      it "プロフィール文が300文字以上" do
        expect(build(:user, :too_long_profile)).to_not be_valid
      end

    end
  end
end
