From: Andreas Hartmetz <ahartmetz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: FS corruption bug(?) and tools bug in 2.0.11
Date: Tue, 17 Mar 2009 00:40:08 +0100
Message-ID: <200903170040.08486.ahartmetz@gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

I've been using NILFS2 for a while to keep my subversion working copies on an 
8 GB SDHC card, which speeds up updating and compilation quite a bit. There is 
no other FS that works equally for consumer flash devices, it seems.
However, after upgrading to 2.0.11 I noticed two problems: something that 
looks like file system corruption and something that looks like a bug in the 
command-line parser of mkfs.nilfs... I didn't lose any data because a) the 
data on the FS never contains much uncommitted work and b) I make the 
occasional backup of that FS. Note that I have recreated the filesystem from 
backup twice and every time I eventually got the same problems. The second 
time I also uninstalled all distro packages related to NILFS to make sure that 
only the self compiled 2.0.11 version of everything would be used (distro 
version is 2.0.8). The distro is Kubuntu Intrepid aka 8.10, kernel
"2.6.27-11-generic" on AMD64.
I'll copy and paste my notes on that here in the hope that you can help.

# mkfs.nilfs2 -c /dev/sdc1
mkfs.nilfs2 ver 2.0
Internal error: command line buffer overflow

# mkfs.nilfs2 -qc /dev/sdc1
<no output, seems to work.>

the command only takes about three seconds to complete so it can't possibly
have checked the whole 8 gigabyte flash card, i.e. it did not seem to respect
the -c option.

-----------------------------------

NILFS2 on /dev/sdc1, fstab line is:

/dev/sdc1       /mnt/flash     nilfs2  noatime 0       3


svn up, aborts with errors.
dmesg output
------------
[14242.114303] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #190181: unaligned directory entry - offset=0,
inode=2531906049332683555, rec_len=8995, name_len=35
[14242.129674] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #190158: unaligned directory entry - offset=0,
inode=2531906049332683530, rec_len=8995, name_len=35
[14242.130674] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #190207: unaligned directory entry - offset=0,
inode=2531906049332683555, rec_len=8995, name_len=35
[14242.205045] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #190562: directory entry across blocks - offset=0,
inode=2338615488501870624, rec_len=8224, name_len=32
[14242.212169] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #190752: unaligned directory entry - offset=0,
inode=7310012279379079202, rec_len=29806, name_len=95
[14242.269919] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #190985: directory entry across blocks - offset=0,
inode=2538746430037044840, rec_len=12592, name_len=48
[14242.865500] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #195062: unaligned directory entry - offset=0,
inode=2338328528344328751, rec_len=26982, name_len=108
[14242.867235] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #195086: unaligned directory entry - offset=0,
inode=7959675879069655115, rec_len=25914, name_len=111
[14242.868983] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #195139: unaligned directory entry - offset=0,
inode=6075672694649528352, rec_len=30821, name_len=116
[14245.428635] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #190264: unaligned directory entry - offset=0,
inode=7959675879052877899, rec_len=27450, name_len=101


I reboot the machine, the FS is remounted and I try to run svn up again.

~/ksvn/kdebase$ svn up
svn: In directory 'runtime/pics'
svn: Error processing command 'delete-entry' in 'runtime/pics'
svn: Directory 'runtime/pics/oxygen/256x256/.svn' containing working copy
admin area is missing

dmesg output 
------------
[ 3004.620074] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #190207: directory entry across blocks - offset=0,
inode=2524879458127786032, rec_len=26988, name_len=110                                        
[ 3005.308071] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #190264: unaligned directory entry - offset=0,
inode=732160890781327732, rec_len=2683, name_len=32                                               
[ 3005.676058] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #190752: unaligned directory entry - offset=0,
inode=7959675879069655115, rec_len=25914, name_len=111                                            
[ 3006.837570] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #195139: unaligned directory entry - offset=0,
inode=7020656034781085021, rec_len=21293, name_len=112                                            
[ 3006.914364] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #195062: directory entry across blocks - offset=0,
inode=8316292897441851951, rec_len=26144, name_len=105                                        
[ 3007.562145] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #195086: unaligned directory entry - offset=0,
inode=7163375852442356347, rec_len=2618, name_len=32                                              
[ 3009.145529] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #190985: unaligned directory entry - offset=0,
inode=4110223406904511033, rec_len=12594, name_len=51                                             
[ 3009.746186] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #190562: directory entry across blocks - offset=0,
inode=3345174470605941032, rec_len=24944, name_len=116                                        
[ 3012.429727] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #190158: directory entry across blocks - offset=0,
inode=8243122672032051813, rec_len=26144, name_len=111                                        
[ 3012.629580] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #190181: unaligned directory entry - offset=0,
inode=7020101786482581605, rec_len=27746, name_len=101                                            
[ 3045.451829] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #87160: directory entry across blocks - offset=0, inode=40,
rec_len=17060, name_len=0                                                            
[ 3058.621540] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #103489: directory entry across blocks - offset=0,
inode=8315165955255919981, rec_len=26912, name_len=110                                        
[ 3058.813533] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #103403: unaligned directory entry - offset=0,
inode=8462108810963066982, rec_len=25710, name_len=68                                             
[ 3072.984072] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #102804: unaligned directory entry - offset=0,
inode=7589802822550691880, rec_len=25965, name_len=32                                             
[ 3179.984590] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #138939: directory entry across blocks - offset=0,
inode=8020383670918344547, rec_len=25956, name_len=32                                         
[ 3185.369533] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #139013: directory entry across blocks - offset=0,
inode=2314861456988438784, rec_len=8224, name_len=32                                          
[ 3189.544583] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #145817: unaligned directory entry - offset=0,
inode=7959675879069655115, rec_len=27962, name_len=105                                            
[ 3189.700592] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #141177: directory entry across blocks - offset=0,
inode=2314885530818453536, rec_len=8224, name_len=32                                          
[ 3190.228572] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #143609: unaligned directory entry - offset=0,
inode=7594590895110515027, rec_len=26727, name_len=116                                            
[ 3190.249262] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #143806: unaligned directory entry - offset=0,
inode=8247308577155673461, rec_len=25461, name_len=116                                            
[ 3190.300576] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #143529: unaligned directory entry - offset=0,
inode=2317427766124110953, rec_len=8254, name_len=48                                              
[ 3190.309380] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #143536: unaligned directory entry - offset=0,
inode=8318823019731055932, rec_len=28521, name_len=110                                            
[ 3190.321260] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #143567: unaligned directory entry - offset=0,
inode=7959675879069655115, rec_len=25914, name_len=111                                            
[ 3190.341243] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #143769: unaligned directory entry - offset=0,
inode=2338328528344328751, rec_len=26982, name_len=108                                            
[ 3190.796576] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #141264: unaligned directory entry - offset=0,
inode=4836901365094165039, rec_len=28783, name_len=121
[ 3191.548590] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #144728: directory entry across blocks - offset=0,
inode=2314885530817018731, rec_len=8224, name_len=32
[ 3191.984592] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #144670: directory entry across blocks - offset=0,
inode=7236828773846303588, rec_len=8232, name_len=99
[ 3194.080580] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #138549: unaligned directory entry - offset=0,
inode=2334675641803106676, rec_len=8289, name_len=103
[ 3194.176587] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #138883: rec_len is smaller than minimal - offset=0,
inode=727905341920923785, rec_len=0, name_len=0
[ 3194.189268] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #138781: rec_len is smaller than minimal - offset=1368, inode=0,
rec_len=0, name_len=0
[ 3195.473270] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #140026: unaligned directory entry - offset=0,
inode=7959675879069655115, rec_len=27962, name_len=105
[ 3204.888576] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #183146: directory entry across blocks - offset=0,
inode=2314885436782765427, rec_len=29728, name_len=104
[ 3204.897364] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #183197: directory entry across blocks - offset=0,
inode=737228217482769249, rec_len=8224, name_len=32
[ 3204.909230] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #183164: unaligned directory entry - offset=0,
inode=8082308135495420279, rec_len=26475, name_len=73
[ 3204.917354] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #183224: directory entry across blocks - offset=0,
inode=2308722778048130922, rec_len=8224, name_len=32
[ 3205.628580] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #139985: rec_len is smaller than minimal - offset=0,
inode=727905341920923785, rec_len=0, name_len=0
[ 3205.637285] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #139992: rec_len is smaller than minimal - offset=0,
inode=727905341920923785, rec_len=0, name_len=0
[ 3206.068580] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #139101: directory entry across blocks - offset=0,
inode=7308604759679987311, rec_len=26920, name_len=44
[ 3206.084586] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #139113: unaligned directory entry - offset=0,
inode=2338328528344328751, rec_len=26982, name_len=108
[ 3206.152570] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #140005: unaligned directory entry - offset=0,
inode=7959675879069655115, rec_len=27962, name_len=105
[ 3206.876578] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #185980: unaligned directory entry - offset=0,
inode=8511922461568430697, rec_len=26991, name_len=100
[ 3207.013159] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #186049: directory entry across blocks - offset=0,
inode=7597420881895033403, rec_len=8292, name_len=85
[ 3207.028580] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #185987: unaligned directory entry - offset=0,
inode=3276198757563660133, rec_len=26430, name_len=101
[ 3207.616584] NILFS error (device sdc1): nilfs_check_page: bad entry in
directory #140062: unaligned directory entry - offset=0,
inode=3186359615545224757, rec_len=12597, name_len=46

Cheers,
Andreas
