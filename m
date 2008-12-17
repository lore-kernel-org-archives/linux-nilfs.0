From: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Subject: samba hanging with 100% cpu load
Date: Wed, 17 Dec 2008 13:02:59 +0100 (CET)
Message-ID: <41366.212.24.212.169.1229515379.squirrel@www.prnet.org>
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

I am using samba to serve files from a nilfs2 filesystem. From time to
time, I have smbd's hanging in state R with 100% cpu usage. Even kill
-KILL won't kill them. If I do an smbstatus it show me open files on the
nilfs2 filesystem which are not opened by any share. It started appearing
when I started using nilfs2, so I think it could be nilfs2 related but I'm
not sure. Did anyone experience similiar problems with nilfs2 and samba ?

Thanks in advance
Bye,
David Arendt
