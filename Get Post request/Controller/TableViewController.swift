//
//  TableViewController.swift
//  Get Post request
//
//  Created by Roman Belov on 16.05.2022.
//

import UIKit

class TableViewController: UITableViewController {
    
    private var courses = [Course]()
    private var courseName: String?
    private var courseURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global().async {
            NetworkManager.fetchCourseData { coursesArray in
                self.courses = coursesArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        let course = courses[indexPath.row]
        
        cell.courseNameLabel.text = course.name
        cell.numberOfLessons.text = "Number of lessons: \(course.numberOfLessons)"
        cell.numberOfTests.text = "Number of tests: \(course.numberOfTests)"
        
        DispatchQueue.global().async {
            guard let imageURL = URL(string: course.imageURL) else { return }
            guard let data = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                cell.courseImage.image = UIImage(data: data)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webVC = segue.destination as! WebViewController
        webVC.selectedCourse = courseName
        
        if let url = courseURL {
            webVC.courseURL = url
        }
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell {
            configureCell(cell: cell, for: indexPath)
            return cell
        }

        return UITableViewCell()
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        
        courseName = course.name
        courseURL = course.link
        
        performSegue(withIdentifier: "ToWebVC", sender: self)
    }



}
