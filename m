From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: some questions
Date: Sun, 04 May 2008 18:16:59 +0200
Message-ID: <481DE17B.3080407@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
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
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

I am very interested in nilfs2 so I have some questions ?

1. If I understood well, nilfs is always appending to the end (is this 
true or is also other data modified, for example to update pointers ?). 
What is happening if I have deleted files and cleanerd deletes the 
snapshots ? Will this space be written by further write operations or 
will it be lost ?
2. I suppose that some fragmentation will build up, is there any 
defragmentation tool planned ?
3. How robust is nilfs to device errors like bad sectors ? For example 
if you have a disk image where bad sectors are replaced by zeros, will 
you still be able to recover data from other sectors ?
