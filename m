From: nezmer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: Pause intervals when copying/extracting an archive
Date: Sat, 16 May 2009 20:15:55 +0300
Message-ID: <20090516171555.GA21962@nezmer.homelinux.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
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

Hi ,

Kernel : 2.6.30-rc5-git3 .
nilfs2 partition : 1GB USB flash disk .

I have a rar archive with 10 mp3 files in it . When I copy this file to
a nilfs2 partition the progress pauses(freezes) in certain intervals .
the same thing happens when I try to extract the archive . this 'bug'
causes the extraction time to jump from <2s (ext4,JFS,XFS) to 29s in
nilfs2 . Those intervals are 100% reproducible here . 

I have no idea how to get a detailed log of what's going on with nilfs2 . So If you need that log , Just tell me how can I get it .

Estimated calculation of pause intervals in MB :

unrar e file.rar #(60.5MB)
12.732
28.52
42.028
56.768

cp file.rar /media/nilfsTest/
14.1
28.1
42.2
56.2
