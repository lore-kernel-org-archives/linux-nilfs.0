From: T-Machine <tmachinecorp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: "Drastic I/O error (write(2)): No space left on
	device"
Date: Tue, 23 Jun 2009 07:47:20 -0400
Message-ID: <4A40C0C8.90402@gmail.com>
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

Hi; Using NILFS2 - nilfs-utils-2.0.12 / 2.0.14 - w. kernel ..6.29.5 & 
..6.30 (Slackware & SlamD & BW64)...
... tried both, as part of the main tree, as well as modules.
1) Problem - example: bonnie++ "Drastic I/O error (write(2)): No space 
left on device"; (8G space 2G RAM)
Same in "direct" writes - no bonnie++ etc.
The nilfs partition simply runs out of space at ~10%.
2) nilfs_cleanerd does not apper to start with "mount". (Why... seems to 
be somewhat elusive. Can't  replicate consistently.
Now, there was a post - 1-2 months ago - where the answer to this 
problem was to increase the B-tree option to "-B 38[???]", which, at 
that time seemed to have solved the issue. However, that number seemed 
to be *very specific*, and unfortunetaly we "lost" that post.

Example: "mkfs -t nilfs2 *** -B 32768 *** /dev/main_node50G/test/5g" -> 
will fail *later*, but will fail with I/O error "disk full", then 
WITHOUT the *** -B 32768 ***. (Not sure if 32768 is correct. In the 
"lost post" it was 38???, if memory servers.)

Appreciate any help.
Ian
