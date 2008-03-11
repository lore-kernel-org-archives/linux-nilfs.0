From: bill-ozn5a1fpZJs3uPMLIKxrzw@public.gmane.org
Subject: nilfs and nfs
Date: Tue, 11 Mar 2008 16:46:09 -0400 (EDT)
Message-ID: <25256.128.221.197.20.1205268369.squirrel@webmail.cs.uml.edu>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
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
Content-Type: text/plain; charset="windows-1252"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Is there a way to export an NILFS object over NFS ?  exportfs errors with
=93/object does not support NFS export=94 when I attempt to include an en=
try
in /etc/exports for /object, which is an NILFS object =85 I=92ve tried us=
ing
the fsid=3D option in the exports entry but this doesn=92t seem to help .=
..
any info would be appreciated ... Bill



-----------------------------------------
This email was sent using SquirrelMail.
   "Webmail for nuts!"
http://squirrelmail.org/
