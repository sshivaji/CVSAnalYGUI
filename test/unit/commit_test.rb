require 'test_helper'

class CommitTest < ActiveSupport::TestCase

  def setup
    @commit1 = FactoryGirl.create(:scmlog)

    @commit2 = FactoryGirl.create(:scmlog, :is_bug_fix => true)
    hunk1 = FactoryGirl.create(:hunk, :commit => @commit2)
    hunk_blame1 = FactoryGirl.build(:hunk_blame, :hunk => hunk1)
    @commit1.hunk_blames << hunk_blame1    
    
    @commit3 = FactoryGirl.create(:scmlog)

    FactoryGirl.create(:action, :commit=>@commit1, :file_id=>1)
    FactoryGirl.create(:action, :commit=>@commit2, :file_id=>1, :type=>'D')
    FactoryGirl.create(:content, :commit=>@commit1, :file_id=>1)
    FactoryGirl.create(:action, :commit=>@commit1, :file_id=>2)
    FactoryGirl.create(:action, :commit=>@commit3, :file_id=>2)
    @content1 = FactoryGirl.create(:content, :commit=>@commit1, :file_id=>2)
    FactoryGirl.create(:content, :commit=>@commit3, :file_id=>2)
  end
  
  test "is buggy" do
    assert_equal true, @commit1.is_buggy
    assert_equal false, @commit2.is_buggy
  end
  
  test "bug fixing commits" do
    assert_equal @commit2.id, @commit1.bug_fixing_commits[0].id
  end
  
  test "bug introducing commits" do
    assert_equal @commit1.id, @commit2.bug_introducing_commits[0].id
  end
  
  test "get snapshot" do
    assert_equal [@content1], @commit2.snapshot
  end
end
