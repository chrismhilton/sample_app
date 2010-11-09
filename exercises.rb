class Exercises
  def initialize
  end

  #
  # Exercise methods
  #
  def alpha_shuffle
    'abc_def_ghi_jkl_mno_pqr_stu_vwx_yz'.split('_').shuffle.join(':')
  end

  def string_shuffle(s)
    s.split('').shuffle.join(':')
  end  
end
