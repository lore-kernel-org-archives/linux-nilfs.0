From: Delian Krustev <krustev-sueGvCUcFGXR7s880joybQ@public.gmane.org>
Subject: Performance problems over AoE
Date: Sat, 19 Dec 2009 02:24:44 +0200
Message-ID: <200912190224.46774.krustev@krustev.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org


	Hi All,

Nice to meet you :-)

I'm having performance problems with NILFS2 running on
AoE (Ata over Ethernet) device.

I'm able to get around 5/10 MB sequential write speed for over a device
which is capable of 100MB/s.

I've described the problem and my setup in details on a web page:

http://krustev.net/w/articles/Backup_service_and_software_block_devices_over_the_net/


and will be thankful if you take a look and give some ideas.

And one other question.
Is there a way to disable the auto check point creation ?


Cheers
--
Delian
